# == Schema Information
# Schema version: 12
#
# Table name: people
#
#  id              :integer       default(0), not null, primary key
#  title           :string(255)   default('''''')
#  first_name      :string(255)   default('''''')
#  middle_name     :string(255)   default('''''')
#  last_name       :string(255)   default('''''')
#  suffix          :string(255)   default('''''')
#  birthday        :date          
#  email           :string(255)   default('''''')
#  login           :string(255)   default('''''')
#  hashed_password :text          default('''''')
#  created_on      :date          
#  notes           :text          default('''''')
#  location_id     :integer       default(0)
#

class Person < ActiveRecord::Base
  require "digest/sha1"

  belongs_to :location
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
  
  def change_location(new_location, date = Time.now)
    change = Change.new
    change.change_type = Change.PERSON_LOCATION
    change.old_value = self.location
    change.new_value = new_location
    change.effective_date = date
    change.person_id = self.id
    change.save!
    self.location = new_location
    self.save!
  end

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
