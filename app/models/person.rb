# == Schema Information
# Schema version: 10
#
# Table name: people
#
#  id              :integer       default(0), not null, primary key
#  title           :string(255)   default()
#  first_name      :string(255)   default()
#  middle_name     :string(255)   default()
#  last_name       :string(255)   default()
#  suffix          :string(255)   default()
#  birthday        :date          
#  email           :string(255)   default()
#  login           :string(255)   default()
#  hashed_password :text          default()
#  created_on      :date          
#  notes           :text          default()
#

class Person < ActiveRecord::Base
  require "digest/sha1"

  has_one :location
  has_many :items
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

  def try_to_login
    Person.login(self.login, self.password)
  end

  def try_email_login
    Person.email_login(self.login, self.password)
  end

  def age
    age_in_seconds = Time.now - self.birthday
    age_in_years = age_in_seconds / 1.years
    age = age_in_years.floor.to_i
  end

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
