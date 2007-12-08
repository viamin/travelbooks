# == Schema Information
# Schema version: 14
#
# Table name: people
#
#  id              :integer         not null, primary key
#  title           :string(255)     
#  first_name      :string(255)     not null
#  middle_name     :string(255)     
#  last_name       :string(255)     not null
#  suffix          :string(255)     
#  birthday        :date            not null
#  email           :string(255)     not null
#  login           :string(255)     not null
#  hashed_password :text            
#  created_on      :date            
#  notes           :text            not null
#

# consider dropping login
class Person < ActiveRecord::Base
  require "digest/sha1"
  has_many :changes
  has_many :locations, :through => :changes
  has_many :items
  has_many :photos
  validates_uniqueness_of :login, :message => "That user name is already taken"
  validates_uniqueness_of :email, :on => :create, :message => "There is already an account using that email address"
  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_presence_of :login, :on => :create, :message => "can't be blank"
  validates_presence_of :password, :on => :create, :message => "can't be blank"
  validates_presence_of :first_name, :on => :create, :message => "can't be blank"
  validates_confirmation_of :password
  validates_format_of :email, 
		      :with => /^(.+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
	
  validates_format_of :login, 
		      :with => /[-_a-zA-Z0-9]+/,
		      :message => "- Only alphanumeric characters, '-' (dash) and '_' (underscore) are allowed in your login name"
	validates_length_of :password, :within => 6..40, :on => :create, :too_long => 'must be 40 characters or less', :too_short => 'must be at least 6 characters'

  attr_accessor :password
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.first_name = String.new if self.first_name.nil?
      self.middle_name = String.new if self.middle_name.nil?
      self.last_name = String.new if self.last_name.nil?
      self.email = String.new if self.email.nil?
      self.login = String.new if self.login.nil?
      self.notes = String.new if self.notes.nil?
      self.password = String.new if self.password.nil?
      self.birthday = Time.local(2007, 5, 23) if self.birthday.nil?
    end
  end
  
  def before_create
    self.hashed_password = Person.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end

  def self.login(name, password)
    hashed_password = Person.hash_password(password || "")
    Person.find(:first, :conditions => { :login => name, :hashed_password => hashed_password })
  end

  def self.email_login(name, password)
    hashed_password = Person.hash_password(password || "")
    Person.find(:first, :conditions => { :email => name, :hashed_password => hashed_password })
  end

  def age
=begin old way
    age_in_seconds = Time.now.to_i - self.birthday.to_i
    age_in_years = age_in_seconds / 1.years
    age = age_in_years.floor.to_i
=end
    age_in_days = Date.today - self.birthday.to_date
    age = (age_in_days / 365).floor.to_i
  end
  
  def main_photo
    #selects the main photo for profile page
    main_photo = self.photos.detect { |photo| photo.photo_type == 1 } || self.photos.first
    if main_photo.nil?
      Photo.default
    end
  end
  
  #checks all location changes for this person and find the current information
  def latest_location
    changes_list = self.changes.clone
    all_locations = changes_list.delete_if {|change| change.change_type == 1}
    all_locations.sort {|x,y| x.effective_date <=> y.effective_date}
    Location.find(all_locations.last.new_value)
  end
  
  def current_location
    self.latest_location
  end
  
  def change_location(new_location, date = Time.now)
    change = Change.new
    change.change_type = 2
    change.old_value = self.latest_location.id
    change.new_value = new_location.id
    change.effective_date = date
    change.person_id = self.id
    change.save
    self.changes << change
    change.save
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
