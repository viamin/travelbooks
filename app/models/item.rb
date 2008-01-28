# == Schema Information
# Schema version: 19
#
# Table name: items
#
#  id          :integer         not null, primary key
#  tbid        :string(255)     
#  name        :string(255)     not null
#  description :text            not null
#  person_id   :integer         
#  created_on  :date            
#

require 'digest/sha1'

class Item < ActiveRecord::Base
  has_many :changes
  has_many :locations, :through => :changes do
    def current(as_of = nil)
      as_of = Time.now if as_of.nil?
      Location.find(Change.find(:first, :conditions => ["change_type=? and effective_date<=?", Change::OWNERSHIP, as_of], :order => "effective_date DESC").new_value)
    end
  end
  has_many :photos
  belongs_to :person
  validates_uniqueness_of :tbid
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.name = String.new if self.name.nil?
      self.description = String.new if self.description.nil?
    end
  end
  
  def generate_tbid
    digest = Digest::SHA1.new
    digest << Time.now.to_s
    digest << self.id.to_s
    digest << self.description
    tbid = digest.hexdigest
    timing "tbid: #{tbid}"
    self.tbid = tbid.slice(2...10)
    until self.save # if the id is not unique
      self.generate_tbid
    end
    self
  end

  def change_owners(new_owner, date = Time.now)
    change = Change.new
    change.change_type = Change::OWNERSHIP
    change.old_value = self.person.id
    change.new_value = new_owner.id
    change.effective_date = date
    change.item_id = self.id
    change.save
    self.person = new_owner
    self.changes << change
    change.save
    self.save!
  end
  
  # Determines all of the places a given item has traveled and returns a hash of locations with 
  # date indices
  def get_trail(start_date = nil, end_date = nil)
    start_date = Time.local(2006, 5, 23) if start_date.nil?
    end_date = Time.now if end_date.nil?
    person_moves = Array.new
    # Two ways this can change: a person can give an item to someone else in a different location,
    # or a person with the item can move to another location. Both cases need to be accounted for.
    switches = Change.find(:all, :conditions => ["change_type = ? and item_id = ? and effective_date >= ? and effective_date <= ?", Change::PERSON_LOCATION, self.id, start_date, end_date], :order => "effective_date")
    unless switches.empty?
      switches.each_with_index do |change, index|
        next_index = index + 1
        switches.last == change ? next_change = nil : next_change = switches[next_index]
        next_change.nil? ? range_end = end_date : range_end = next_change.effective_date
        moves = Change.find(:all, :conditions => ["change_type = ? and person_id = ? and effective_date >= ? and effective_date < ?", Change::PERSON_LOCATION, change.item.person, change.effective_date, range_end])
        moves.each { |move| person_moves << move } unless moves.empty?
      end
    end
    # Now we should have two arrays of changes which track how the book has moved. 
    # We need to merge them and sort them by effective_date
    all_changes = switches.concat( person_moves )
    sorted_changes = all_changes.sort { |a, b| a.effective_date <=> b.effective_date }
    sorted_changes
  end
  
  # This function will calculate how far the item has travelled, and store the data in 
  # the database. First it will check for updated data, and if it's not there, calculate
  def miles_travelled(locations)
    #Calculate distance from one location to another (do this in the Location model)
    legs = Array.new
    total_distance = 0
    locations.each_with_index do |location, index|
      locations.first == location ? beginning = location : beginning = ending
      ending = location unless locations.first == location
      legs << beginning.distance_to(ending) unless locations.first == location
    end
    legs.each { |distance| total_distance += distance }
    total_distance
  end
  
  # This code is taken from the person model and needs to be changed
  def latest_location
    self.all_locations.last
  end
  
  def current_location
    changes_list = self.changes.clone
#    timing "Changes list: #{changes_list.pretty_inspect}"
    location = changes_list.delete_if {|change| change.change_type != Change::ITEM_LOCATION }.sort { |x,y| x.effective_date <=> y.effective_date }.collect! {|c| Location.find(c.new_value)}.last
    if location.nil?
#      timing "Using latest location"
      location = self.latest_location
    end
    location
  end
  
  def all_locations
    changes_list = self.changes.clone
    all_locations = changes_list.delete_if {|change| ((change.change_type == Change::OWNERSHIP) || (change.change_type == Change::PERSON_LOCATION) || (change.change_type == Change::PERSON_MAIN_LOCATION)) }
    all_locations.sort {|x,y| x.effective_date <=> y.effective_date}
    all_locations.collect! {|c| Location.find(c.new_value)}
  end
  
end
