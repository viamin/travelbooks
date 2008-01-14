# == Schema Information
# Schema version: 17
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
#  nickname        :string(255)     
#  headline        :string(255)     
#  salt            :string(255)     
#

# consider dropping login
class Person < ActiveRecord::Base
  require "digest/sha2"
  has_many :changes
  has_many :locations, :through => :changes
  has_many :items
  has_many :photos
  validates_uniqueness_of :login, :message => "That user name is already taken"
  validates_uniqueness_of :email, :on => :create, :message => "There is already an account using that email address"
  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_presence_of :login, :on => :create, :message => "can't be blank"
  validates_presence_of :password, :on => :create, :message => "can't be blank"
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
      self.birthday = Time.local(1997, 1, 1) if self.birthday.nil?
      self.salt = Digest::SHA2.hexdigest(rand.to_s)[5..10]
    end
  end
  
  def before_create
    self.hashed_password = Person.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end

  def display_name
    if self.nickname.nil? || self.nickname.empty?
      display_name = self.first_name
    else
      display_name = self.nickname
    end
    display_name
  end

  def self.login(name, password)
    hashed_password = Person.hash_password(password || "")
    @person = Person.find(:first, :conditions => {:login => name})
    if "#{@person.hashed_password}" == "#{hashed_password}#{@person.salt}"
      return_val = @person
    else
      return_val = nil
    end
    return_val
  end

  def self.email_login(email, password)
    hashed_password = Person.hash_password(password || "")
    @person = Person.find(:first, :conditions => {:email => email})
    if "#{@person.hashed_password}" == "#{hashed_password}#{@person.salt}"
      return_val = @person
    else
      return_val = nil
    end unless @person.nil?
    return_val
  end
  
  def change_password(old_pass, new_pass)
    verified = ("#{self.hashed_password}" == "#{Person.hash_password(old_pass)}#{self.salt}")
    if verified
      new_hash = Person.hash_password(new_pass)
      self.hashed_password = "#{new_hash}#{self.salt}"
      self.save!
    end
    return verified
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
    main_photo = self.photos.detect { |photo| photo.photo_type == Photo::MAIN } || self.photos.first
    if main_photo.nil?
      main_photo = Photo.default
    end
    main_photo
  end
  
  #checks all location changes for this person and find the current information
  def latest_location
    self.all_locations.last
  end
  
  def current_location
    self.latest_location
  end
  
  def all_locations
    changes_list = self.changes.clone
    all_locations = changes_list.delete_if {|change| change.change_type == 1}
    all_locations.sort {|x,y| x.effective_date <=> y.effective_date}
    all_locations.collect! {|c| Location.find(c.new_value)}
  end
  
  # remove the association with this location
  def remove_location(location)
    
  end
  
  # change the active location if someone else is using old_location
  def swap_locations(old_location, new_location)
    
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
  
  # shows all travellerbooks the person has had at some point
  def all_items
    item_array = Change.find(:all, :conditions => {:change_type => 1, :new_value => self.id})
    timing "#{item_array.pretty_inspect}"
    items = item_array.collect!{ |item| Item.find(item.item_id) unless item.item_id.nil?}.compact.uniq unless item_array.empty?
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
  
  def friends
    friends = Friend.find(:all, :conditions => {:owner_person_id => self.id})
    friends.map! {|f| Person.find(f.entry_person_id) unless f.nil?}
  end
  
  def self.titles
    titles = ["", "Mr.", "Mrs.", "Ms."]
  end
  
  def self.suffixes
    suffixes = ["", "Sr.", "Jr.", "III"]
  end

  private
  def self.hash_password(password)
    main = Digest::SHA2.hexdigest(password)
  end

end
