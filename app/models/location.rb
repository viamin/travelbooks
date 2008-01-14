# == Schema Information
# Schema version: 17
#
# Table name: locations
#
#  id             :integer         not null, primary key
#  description    :string(255)     not null
#  loc_type       :integer         default(1)
#  person_id      :integer         
#  item_id        :integer         
#  credit_card_id :integer         default(0)
#  address_line_1 :string(255)     not null
#  address_line_2 :string(255)     
#  city           :string(255)     not null
#  state          :string(255)     not null
#  zip_code       :string(255)     not null
#  country        :string(255)     not null
#  latitude       :string(255)     not null
#  longitude      :string(255)     not null
#  altitude_feet  :integer         default(0)
#  date_start     :datetime        
#  date_end       :datetime        
#  public         :boolean         
#

class Location < ActiveRecord::Base
  belongs_to :item
  belongs_to :person
  belongs_to :credit_card
  has_many :changes
  validates_presence_of :country, :message => "must be chosen"
  
  # Locations types
  ADDRESS = 1
  GPS = 2
  
  attr_reader :ADDRESS
  attr_reader :GPS
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.description = String.new if self.description.nil?
      self.address_line_1 = String.new if self.address_line_1.nil?
      self.address_line_2 = String.new if self.address_line_2.nil?
      self.city = String.new if self.city.nil?
      self.state = String.new if self.state.nil?
      self.zip_code = String.new if self.zip_code.nil?
      self.latitude = String.new if self.latitude.nil?
      self.longitude = String.new if self.longitude.nil?
      self.country = String.new if self.country.nil?
    end
  end
  
  # Determines if the location is used in more than one place. 
  def used_elsewhere?
    true #for testing purposes...
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
      #Check that the address is more than just the country
      return true if self.state != ""
    else
      return true if self.latitude != "" && self.longitude != ""
    end
    return false
  end
  
  def address(sep = "")
    "#{self.address_line_1}#{sep}#{self.address_line_2}"
  end
  
  def city_state_zip
    "#{self.city}, #{self.state} #{self.zip_code}"
  end
  
  # This method will return true or false depending on if the new location information added
  # is a new location indicating a new change object is needed, or if it is simply more detailed
  # information for the current location
  def is_different_than?(params_hash)
    #compare each item in params_hash against the data in self
    difference_count = 0
    params_hash.each { |param, value| difference_count += 1 unless self.send(param).down_case.strip == value.down_case.strip }
    return true if difference_count > DIFFERENCE_THRESHOLD
    return false
  end
  
end
