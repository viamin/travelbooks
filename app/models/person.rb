# == Schema Information
# Schema version: 13
#
# Table name: people
#
#  id              :integer       not null, primary key
#  title           :string(255)   default(NULL)
#  first_name      :string(255)   default(NULL)
#  middle_name     :string(255)   default(NULL)
#  last_name       :string(255)   default(NULL)
#  suffix          :string(255)   default(NULL)
#  birthday        :date          
#  email           :string(255)   default(NULL)
#  login           :string(255)   default(NULL)
#  hashed_password :text          default(NULL)
#  created_on      :date          
#  notes           :text          default(NULL)
#

class Person < ActiveRecord::Base
  require "digest/sha1"
  has_many :changes
  has_many :locations, :through => :changes
  has_many :items
  has_many :photos
  validates_uniqueness_of :login, :email
  validates_presence_of :email, :login, :password, :first_name
  validates_confirmation_of :password
  validates_format_of :email,
		      :with => /^(.+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :login,
		      :with => /[-_a-zA-Z0-9]+/,
		      :message => "- Only alphanumeric characters, '-' (dash) and '_' (underscore) are allowed in your login name"
  validates_length_of :password,
		      :in => 6..40, 
		      :too_long => 'must be 40 characters or less',
		      :too_short => 'must be at least 6 characters'

  attr_accessor :password
  
  def before_create
    self.hashed_password = Person.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end

  def self.login(name, password)
    hashed_password = hash_password(password || "")
    find(:first, :conditions => ["login = ? and hashed_password = ?", name, hashed_password])
  end

  def self.email_login(name, password)
    hashed_password = hash_password(password || "")
    find(:first, :conditions => ["email = ? and hashed_password = ?", name, hashed_password])
  end

  def age
=begin old way
    age_in_seconds = Time.now.to_i - self.birthday.to_i
    age_in_years = age_in_seconds / 1.years
    age = age_in_years.floor.to_i
=end
    age_in_days = Date.today - self.birthday
    age = (age_in_days / 365).floor.to_i
  end
  
  def main_photo
    #selects the main photo for profile page
    main_photo = self.photos.detect { |photo| photo.photo_type == 1 } || self.photos.first
  end
  
  #checks all location changes for this person and find the current information
  def latest_location
    all_locations = self.changes.delete_if {|change| change.change_type == 1}
    all_locations.sort {|x,y| x.effective_date <=> y.effective_date}
    all_locations.last
  end
  
  def change_location(new_location, date = Time.now)
    change = Change.new
    change.change_type = 2
    change.old_value = self.latest_location
    change.new_value = new_location
    change.effective_date = date
    change.person_id = self.id
    change.save!
#    self.locations << new_location
#    self.save!
  end
  
  # This function will calculate how far the user has travelled himself, and store the data in 
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

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
