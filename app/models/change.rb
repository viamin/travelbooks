# == Schema Information
# Schema version: 20090214004612
#
# Table name: changes
#
#  id             :integer         not null, primary key
#  change_type    :integer
#  item_id        :integer
#  person_id      :integer
#  location_id    :integer
#  old_value      :string(255)
#  new_value      :string(255)     not null
#  effective_date :date
#  created_on     :date
#

#Need to decide if location_id is necessary

class Change < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  belongs_to :location
  has_one :destination
  
  # possible change_types:
  OWNERSHIP = 1
  PERSON_LOCATION = 2
  PERSON_MAIN_LOCATION = 3
  ITEM_LOCATION = 4
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.old_value = String.new if self.old_value.nil?
      self.new_value = String.new if self.new_value.nil?
    end
  end
  
  def old_person
    Person.where({:id => self.old_value}).first
  end
  
  def old_location
    Location.where({:id => self.old_value}).first
  end
  
  def self.remove_duplicates
    @changes = Change.all.order(:id)
    @remaining_changes = @changes.dup
    @same_as = Hash.new {|hash, key| hash[key] = Array.new}
    @changes.each do |change|
      @remaining_changes.delete(change)
#      timing "#{change.id}: #{@remaining_changes.collect{|ch| ch.id}.pretty_inspect}"
      @remaining_changes.each do |chg|
        if ( (change.id != chg.id) && change.is_identical_to?(chg, true) )
#          timing "Found identical changes"
          @same_as[change.id] << chg
        end
      end
      unless @same_as[change.id].empty?
        @same_as[change.id].each {|chg| @remaining_changes.delete(chg)}
        @same_as[change.id].collect!{|chg| chg.id}
      end
    end
    @same_as = @same_as.delete_if {|k,v| v.empty?}
#   timing "Duplicate changes: #{@same_as.pretty_inspect}"
    @same_as.each do |original, duplicate|
      # find all changes, references to duplicate, etc. and replace them with original
      duplicate.each do |change|
        destinations = Destination.where({:change_id => change})
        begin
          destinations.each {|destination| (destination.change_id = original) && destination.save!}
        end
#        timing "Deleting change #{change}"
        Change.destroy(change)
      end
    end
    @same_as
  end
  
  def is_identical_to?(change, exact = true)
    difference_count = 0
    if exact # if exact match, then check created_on column, otherwise ignore it
      change_hash = change.attributes.delete_if{|col, val| col == "id" || val.nil?}
    else
      change_hash = change.attributes.delete_if{|col, val| col == "id" || col == "created_on" || val.nil?}
    end
    change_hash.each { |column, value| difference_count += 1 unless self.send(column).to_s.strip == value.to_s.strip }
    if difference_count >= Travelbooks::DIFFERENCE_THRESHOLD
      return false
    else
      return true
    end
  end
  
end
