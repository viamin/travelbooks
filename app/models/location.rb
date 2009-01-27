# == Schema Information
# Schema version: 36
#
# Table name: locations
#
#  id             :integer         not null, primary key
#  description    :string(255)     not null
#  loc_type       :integer         default(1)
#  person_id      :integer
#  item_id        :integer
#  address_line_1 :string(255)     not null
#  address_line_2 :string(255)
#  city           :string(255)     not null
#  state          :string(255)     not null
#  zip_code       :string(255)     not null
#  country        :string(255)     not null
#  altitude_feet  :integer         default(0)
#  date_start     :datetime
#  date_end       :datetime
#  public         :boolean
#  lat            :float
#  lng            :float
#  icon           :string(255)
#  status_id      :integer
#

class Location < ActiveRecord::Base
  belongs_to :item
  belongs_to :person
  belongs_to :status
  has_many :changes
  has_many :reviews
  has_many :statistics
  validates_presence_of :country, :message => "must be selected"
  validates_length_of :description, :maximum => 250
  validates_length_of :address_line_1, :maximum => 250
  validates_length_of :address_line_2, :maximum => 250
  validates_length_of :city, :maximum => 250
  validates_length_of :state, :maximum => 250
  validates_length_of :zip_code, :maximum => 250
  validates_length_of :country, :maximum => 250
  acts_as_mappable
  
  include GeoKit::Geocoders
  
  # Locations types
  ADDRESS = 1
  GPS = 2
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.description = String.new if self.description.nil?
      self.address_line_1 = String.new if self.address_line_1.nil?
      self.address_line_2 = String.new if self.address_line_2.nil?
      self.city = String.new if self.city.nil?
      self.state = String.new if self.state.nil?
      self.zip_code = String.new if self.zip_code.nil?
      self.country = String.new if self.country.nil?
    end
  end
  
  def before_save
    # Geocode the address and save the lat/lng returned
    @person = Person.find(self.person_id) unless self.person_id.nil?
    loc = MultiGeocoder.geocode(self.address_to_geocode(@person))
    if loc.success
      self.lat = loc.lat
      self.lng = loc.lng
      self.zip_code = loc.zip unless loc.zip.nil?
    end
    #timing self.pretty_inspect
  end
  
  def person
    Person.find(self.person_id) unless self.person_id.nil?
  end
  
  def item
    Item.find(self.item_id) unless self.item_id.nil?
  end
  
  def self.default
    Location.new(SAMPLE_LOCATION)
  end
  
  # Determines if the location is used in more than one place. 
  def used_elsewhere?
    # check the changes table to see if this location is being used 
    # for more than one change, so really this should be called
    # used_in_more_than_one_place?
    loc_changes = Change.find(:all, :conditions => {:new_value => self.id, :change_type => [Change::PERSON_LOCATION, Change::PERSON_MAIN_LOCATION]})
    if loc_changes.length >= 2
      retval = true
    else
      retval = false
    end
    retval
  end
  
  # Determines if the location is used in any place. 
  def used_anywhere?
    # check the changes table to see if this location is being used 
    # for more than one change, so really this should be called
    # used_in_more_than_one_place?
    places_used = 0
    loc_changes = Change.find(:all, :conditions => {:new_value => self.id, :change_type => [Change::PERSON_LOCATION, Change::PERSON_MAIN_LOCATION]})
    places_used += loc_changes.length
    # Ah, but also need to check people, items and destinations!
    person_array = Person.find(:all, :conditions => {:id => self.person_id})
    places_used += person_array.length
    item_array = Item.find(:all, :conditions => {:id => self.item_id})
    places_used += item_array.length
    status_array = Status.find(:all, :conditions => {:id => self.status_id})
    places_used += status_array.length
    destination_array = Destination.find(:all, :conditions => {:location_id => self.id})
    places_used += destination_array.length
    if places_used >= 1
      retval = true
    else
      retval = false
    end
    retval
  end
  
  def used_in
    Change.find(:all, :conditions => {:new_value => self.id, :change_type => [Change::PERSON_LOCATION, Change::PERSON_MAIN_LOCATION]}).length  
  end
  
  # Calculates the distance between two locations
  def distance_to(location)
    ########### TBD ############
  end
  
  def location_type
    if self.loc_type == ADDRESS
      location_type = "Address"
    else
      location_type = "GPS Coordinates"
    end
    location_type
  end
  
  # This determines if a location created during initial signup should be saved
  # The purpose is to help determine if when a user decides to change their location
  # info, should a new location be created, or the current one edited?
  def has_good_info?
    #Either there's an address, or GPS coordinates
    if self.loc_type == 1
      #Check that the address is at least the country
      return true if self.country != ""
    else
      return false if self.lat.nil? || self.lng.nil?
    end
    return false
  end
  
  def to_s(sep = "")
    "#{self.address(sep)} #{self.city_state_zip}"
  end
  
  def address(sep = "")
    "#{self.address_line_1}#{sep}#{self.address_line_2}"
  end
  
  def city_state_zip
    "#{self.city}, #{self.state} #{self.zip_code} #{self.country}"
  end
  
  # This method will return true or false depending on if the new location information added
  # is a new location indicating a new change object is needed, or if it is simply more detailed
  # information for the current location
  def is_different_than?(params_hash)
    #compare each item in params_hash against the data in self
    difference_count = 0
    params_hash.delete_if{|c,v| c == "id"}.each { |param, value| difference_count += 1 unless (self.send(param).to_s.downcase.strip == value.to_s.downcase.strip) }
    return true if difference_count >= DIFFERENCE_THRESHOLD
    return false
  end
  
  # Removes locations with the same address and GPS coordinates
  def self.remove_duplicates
    @locations = Location.find(:all, :order => :id)
    @remaining_locations = @locations.dup
    @same_as = Hash.new {|hash, key| hash[key] = Array.new}
    @locations.each do |location|
      @remaining_locations.delete(location)
#      timing "#{location.id}: #{@remaining_locations.collect{|loc| loc.id}.pretty_inspect}"
      @remaining_locations.each do |loc|
        if ( (location.id != loc.id) && location.is_identical_to?(loc, true) )
#          timing "Found identical locations"
          @same_as[location.id] << loc
        end
      end
      unless @same_as[location.id].empty?
        @same_as[location.id].each {|loc| @remaining_locations.delete(loc)}
        @same_as[location.id].collect!{|loc| loc.id}
      end
    end
    @same_as = @same_as.delete_if {|k,v| v.empty?}
#   timing "Duplicate locations: #{@same_as.pretty_inspect}"
    @same_as.each do |original, duplicate|
      # find all changes, references to duplicate, etc. and replace them with original
      duplicate.each do |location|
        changes1 = Change.find(:all, :conditions => {:new_value => location})
        changes2 = Change.find(:all, :conditions => {:old_value => location})
        changes3 = Change.find(:all, :conditions => {:location_id => location})
        changes4 = Destination.find(:all, :conditions => {:location_id => location})
        changes5 = Order.find(:all, :conditions => {:shipping_location_id => location})
        changes6 = Photo.find(:all, :conditions => {:location_id => location})
        changes7 = CreditCard.find(:all, :conditions => {:billing_address_location_id => location})
#        all_changes = changes1 + changes2 + changes3 + changes4 + changes5 + changes6 + changes7
#        timing all_changes.uniq.pretty_inspect
        begin
          changes1.each {|change| (change.new_value = original) && change.save!}
          changes2.each {|change| (change.old_value = original) && change.save!}
          changes3.each {|change| (change.location_id = original) && change.save!}
          changes4.each {|change| (change.location_id = original) && change.save!}
          changes5.each {|change| (change.shipping_location_id = original) && change.save!}
          changes6.each {|change| (change.location_id = original) && change.save!}
          changes7.each {|change| (change.billing_address_location_id = original) && change.save!}
        end
        timing "Deleting location #{location}"
        Location.destroy(location)
      end
    end
    @same_as
  end
  
  # Checks for exact matches for removing duplicates (but ignore id column)
  def is_identical_to?(location, exact = false)
    difference_count = 0
    if exact # if exact match, then check description column, otherwise ignore it
      loc_hash = location.attributes.delete_if{|col, val| col == "id" || val.nil?}
    else
      loc_hash = location.attributes.delete_if{|col, val| col == "id" || col == "description" || val.nil?}
    end
    loc_hash.each { |column, value| difference_count += 1 unless self.send(column).to_s.strip == value.to_s.strip }
    if difference_count >= DIFFERENCE_THRESHOLD
      return false
    else
      return true
    end
  end
  
  def address_to_geocode(person)
    unless person.nil?
      case person.location_resolution
      when "City Only"
        address_to_geocode = "#{self.city}, #{self.state}, #{self.country}"
      when "State Only"
        address_to_geocode = "#{self.state}, #{self.country}"
      when "Postal Code Only"
        address_to_geocode = "#{self.state} #{self.zip_code} #{self.country}"
      when "Country Only"
        address_to_geocode = "#{self.country}"
      else
        address_to_geocode = "#{self.address_line_1} #{self.address_line_2} #{self.city} #{self.state} #{self.zip_code} #{self.country}"
      end
    else
      address_to_geocode = "#{self.address_line_1} #{self.address_line_2} #{self.city}, #{self.state} #{self.zip_code}, #{self.country}"
    end
    address_to_geocode
  end
  
  def public_message
    if self.public == true
      public_message = "This location is public"
    else
      public_message = "This location is private"
    end
    public_message
  end
  
  def empty?
    false
  end
  
end
