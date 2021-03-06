# == Schema Information
# Schema version: 20090214004612
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

require 'digest/sha2'

class Item < ActiveRecord::Base
  has_many :changes
  belongs_to :person
  has_many :statuses, :dependent => :destroy do 
    def current(as_of = Time.now)
      order("updated_at desc, created_at desc")
    end
  end
  has_many :photos do
    def main
      where({:photo_type => [Photo::MAIN, Photo::ITEM]})
    end
  end
  
  before_save :set_current_owner
  
  has_many :reviews
  has_many :statistics
  has_and_belongs_to_many :trips
  validates_uniqueness_of :tbid
  validates_length_of :tbid, :maximum => 250
  validates_length_of :name, :maximum => 250
  has_many :locations, :through => :changes do
    def current(as_of = Time.now)
      change = Change.where(["change_type=? and effective_date<=? and item_id=?", Change::ITEM_LOCATION, as_of, proxy_owner.id]).order("effective_date DESC").first
      if change.nil?
        Location.default
      else
        Location.find(change.new_value)
      end
    end
    def sorted(how="ASC") 
      @changes = Change.where({:change_type => Change::ITEM_LOCATION, :item_id => proxy_owner.id}).("effective_date #{how}")
      proxy_owner.trips.each {|trip| trip.destinations.each {|d| @changes << Change.new({:new_value => d.location.id, :effective_date => (d.arrival.to_date || Date.now)}) if d.has_location? } } unless proxy_owner.trips.empty?
#      timing @changes.pretty_inspect
      @changes.sort!{ |x,y| x.effective_date <=> y.effective_date } if @changes.length > 1
      @changes.collect!{ |c| Location.find(c.new_value)}
    end
  end
  has_many :people, :through => :changes do
    def owners(how = "ASC")
      changes = Change.where({:item_id => proxy_owner.id, :change_type => Change::OWNERSHIP}).order("effective_date #{how}")
      changes.collect!{ |c| Person.find(c.new_value)}
      changes.delete_if {|p| p.id == NOBODY_USER }
    end
  end
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.name = "New Book" if self.name.nil?
      self.description = String.new if self.description.nil?
    end
  end
  
  def generate_tbid
    digest = Digest::SHA2.new
    digest << Time.now.to_s
    digest << self.id.to_s
    digest << self.description
    tbid = digest.hexdigest
#    timing "tbid: #{tbid}"
    self.tbid = "TB" + tbid.slice(2...10).upcase
    until self.save # if the id is not unique
      self.generate_tbid
    end
    self
  end
  
  def generate_tbid_no_save
    digest = Digest::SHA2.new
    digest << Time.now.to_s
    digest << self.id.to_s
    digest << self.description
    tbid = digest.hexdigest
#    timing "tbid: #{tbid}"
    self.tbid = "TB" + tbid.slice(2...10).upcase
    self
  end

  def change_owner(new_owner, date = Time.now)
    change = Change.new
    change.change_type = Change::OWNERSHIP
    change.old_value = self.person.id
    change.new_value = new_owner.id
    change.effective_date = date
    change.item_id = self.id
    self.change_location(new_owner, date)
    self.person_id = new_owner.id
    self.changes << change
    change.save
    self.save
  end
  
  def change_location(new_owner, date = Time.now)
    loc_change = Change.new
    loc_change.change_type = Change::ITEM_LOCATION
    loc_change.new_value = new_owner.current_location.id
    loc_change.effective_date = date
    loc_change.item_id = self.id
    loc_change.save
  end
  
  # Determines all of the places a given item has traveled and returns a hash of locations with 
  # date indices
  def get_trail(start_date = nil, end_date = nil)
    start_date = Time.local(2006, 5, 23) if start_date.nil?
    end_date = Time.now if end_date.nil?
    person_moves = Array.new
    # Two ways this can change: a person can give an item to someone else in a different location,
    # or a person with the item can move to another location. Both cases need to be accounted for.
    switches = Change.where(["change_type = ? and item_id = ? and effective_date >= ? and effective_date <= ?", Change::PERSON_LOCATION, self.id, start_date, end_date]).order("effective_date")
    unless switches.empty?
      switches.each_with_index do |change, index|
        next_index = index + 1
        switches.last == change ? next_change = nil : next_change = switches[next_index]
        next_change.nil? ? range_end = end_date : range_end = next_change.effective_date
        moves = Change.where(["change_type = ? and person_id = ? and effective_date >= ? and effective_date < ?", Change::PERSON_LOCATION, change.item.person, change.effective_date, range_end])
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
  
  def add_new_location_change
    if self.current_location.nil?
      return nil
    else
      self.current_location.id
    end
  end
  
  def add_new_location_change=(new_location_id)
    unless (new_location_id.nil? || (!self.current_location.nil? && new_location_id == self.current_location.id))
#      timing "Creating a new item change for Location id:#{new_location_id}"
      @change = Change.new
      @change.change_type = Change::ITEM_LOCATION
      @change.item_id = self.id
      @change.old_value = self.current_location.id unless self.current_location.nil?
      @change.new_value = new_location_id
      @change.effective_date = Time.now
      @change.save
#      timing "Done creating new item change"
    end
    new_location_id
  end
  
  private
  def set_current_owner
    changes = Change.where({:change_type => Change::OWNERSHIP, :item_id => self.id}).order("effective_date")
    latest_owner = changes.last.new_value unless changes.empty?
    self.person_id = latest_owner unless changes.empty?
  end
  
end
