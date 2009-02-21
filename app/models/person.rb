# == Schema Information
# Schema version: 20090214004612
#
# Table name: people
#
#  id               :integer         not null, primary key
#  first_name       :string(255)     not null
#  middle_name      :string(255)
#  last_name        :string(255)     not null
#  email            :string(255)     not null
#  hashed_password  :text
#  created_on       :date
#  nickname         :string(255)
#  salt             :string(255)
#  privacy_flags    :integer         default(0)
#  needs_reset      :boolean
#  login_token      :string(255)
#  private_profile  :boolean
#  last_login       :datetime
#  mail_preferences :integer
#

class Person < ActiveRecord::Base
  require "digest/sha2"
  before_destroy :remove_all_messages
  has_many :changes
  has_many :locations, :through => :changes
  has_many :items
  has_many :trips
  has_many :orders
  has_many :credit_cards, :dependent => :destroy
  has_many :reviews
  has_many :statistics, :dependent => :destroy do
    def countries_visited
      collection = find(:first, :conditions => {:stat_type => Statistic::COUNTRIES_VISITED_COUNT})
      collection.nil? ? 0 : collection.count
    end
    def countries_books_visited
      0
    end
    def miles_travelled
      0
    end
    def miles_books_given_travelled
      0
    end
    def miles_last_book_received_travelled
      0
    end
  end
  has_many :statuses, :dependent => :destroy do
    def current(as_of = Time.now)
      find :first, :order => "updated_at desc, created_at desc"
    end
  end
  has_many :photos, :dependent => :nullify
  has_many :messages do
    def unread
      find(:all, :conditions => {:state => Message::UNREAD})
    end
    def inbox
      find(:all, :conditions => ['state<?', Message::DELETEDBYRECIPIENT], :order => "id desc")
    end
    def sent
      Message.find(:all, :conditions => ["sender=? and state|?!=? and message_type|?!=?", proxy_owner.id, Message::DELETEDBYSENDER, Message::DELETEDBYSENDER, Message::FRIENDREQUEST, Message::FRIENDREQUEST])
    end
  end
  def sent_messages
    Message.find(:all, :conditions => {:sender => self.id}).delete_if {|m| (m.state == (m.state | Message::DELETEDBYSENDER) || (m.message_type == (m.message_type | Message::FRIENDREQUEST) ) ) }
  end
  validates_uniqueness_of :email, :on => :create, :message => "There is already an account using that email address"
  validates_presence_of :email, :on => :create, :message => "can't be blank"
  validates_presence_of :nickname, :on => :create, :message => "can't be blank"
  validates_presence_of :password, :on => :create, :message => "can't be blank"
  validates_confirmation_of :password
  validates_format_of :email, 
		      :with => /^(.+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
	validates_length_of :password, :within => 6..40, :on => :create, :too_long => 'must be 40 characters or less', :too_short => 'must be at least 6 characters'
#	validates_length_of :first_name, :maximum => 250
#  validates_length_of :middle_name, :maximum => 250
#  validates_length_of :last_name, :maximum => 250
  validates_length_of :email, :maximum => 250
  validates_length_of :nickname, :maximum => 250

  attr_accessor :password
  
  # Privacy setting bits (for reference, ^ is Ruby XOR operator)
  NOMESSAGES = 2**0
  NOTVISIBLEONITEMS = 2**1
  CITYONLY = 2**2
  STATEONLY = 2**3
  ZIPONLY = 2**4
  COUNTRYONLY = 2**5
  SHAREVACATIONS = 2**6
  
  # Mail settings bits (On is block)
  MESSAGE = 2**0
  REQUEST = 2**1
  ANNOUNCE = 2**2
  
  
  LOCRESOLUTIONS = ["Full Address", "City Only", "State Only", "Postal Code Only", "Country Only"]
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.first_name = String.new if self.first_name.nil?
      self.middle_name = String.new if self.middle_name.nil?
      self.last_name = String.new if self.last_name.nil?
      self.email = String.new if self.email.nil?
      self.password = String.new if self.password.nil?
      self.salt = Digest::SHA2.hexdigest(rand.to_s)[5..10]
      self.location_resolution = "Full Address"
    end
  end
  
  def all_items
    item_array = Change.find(:all, :conditions => {:change_type => Change::OWNERSHIP, :new_value => self.id})
    items = item_array.collect { |change| Item.find(change.item_id) unless change.item_id.nil?}.concat(self.items).compact.uniq
    items
  end
  
  def items_given
    item_array = Change.find(:all, :conditions => {:change_type => Change::OWNERSHIP, :old_value => self.id})
    items = item_array.collect {|change| Item.find(change.item_id) unless change.item_id.nil?}
  end
  
  def items_received(from = nil)
    not_from = "and old_value=#{from}" unless from.nil?
    old_value_string = "(old_value != #{NOBODY_USER} #{not_from unless not_from.nil?})"
    item_array = Change.find(:all, :conditions => ["change_type = ? and new_value=? and #{old_value_string}", Change::OWNERSHIP, self.id])
    items = item_array.collect {|change| Item.find(change.item_id) unless change.item_id.nil?}
  end
  
  def before_create
    self.hashed_password = Person.hash_password(self.password)
  end
  
  def after_save
#    timing "Clearing password"
    @password = nil
  end
  
  def invisible
    return ((self.privacy_flags & NOTVISIBLEONITEMS) == NOTVISIBLEONITEMS)
  end
  
  def invisible=(value)
    if value == "Yes"
      self.privacy_flags = (self.privacy_flags | NOTVISIBLEONITEMS) 
    else
      self.privacy_flags = (self.privacy_flags - NOTVISIBLEONITEMS) if self.invisible
    end
    self.save
  end
  
  def location_resolution
    case (self.privacy_flags & (CITYONLY | STATEONLY | ZIPONLY | COUNTRYONLY))
    when CITYONLY
      "City Only"
    when STATEONLY
      "State Only"
    when ZIPONLY
      "Postal Code Only"
    when COUNTRYONLY
      "Country Only"
    else
      "Full Address"
    end
  end
  
  def location_resolution=(value)
    case value
    when "City Only"
      arith = CITYONLY
    when "State Only"
      arith = STATEONLY
    when "Postal Code Only"
      arith = ZIPONLY
    when "Country Only"
      arith = COUNTRYONLY
    else
      arith = 0
    end
    self.privacy_flags = self.privacy_flags & (NOMESSAGES | NOTVISIBLEONITEMS | SHAREVACATIONS | arith)
  end
  
  def share_trips
    return ((self.privacy_flags & SHAREVACATIONS) == SHAREVACATIONS)
  end
  
  def share_trips=(value)
    if value == "Yes"
      self.privacy_flags = self.privacy_flags | SHAREVACATIONS
    else
      self.privacy_flags = self.privacy_flags - SHAREVACATIONS if self.share_trips
    end
  end

  def display_name
    if self.nickname.nil? || self.nickname.empty?
      display_name = self.email
    else
      display_name = self.nickname
    end
    display_name
  end
  
  def self.is_valid_login?(login)
    count = Person.find(:all, :conditions => {:email => login}).length
    return (count > 0)
  end

  def self.email_login(email, password)
    person = Person.find(:first, :conditions => {:email => email})
    unless person.nil?
      hashed_password = Person.hash_password("#{password}#{person.salt}" || "")
      if person.hashed_password == hashed_password
        return_val = person
      else
        return_val = Person.old_email_login(person, email, password)
      end
    end
    return_val
  end
  
  def self.old_email_login(person, email, password)
    hashed_password = Person.hash_password(password || "")
    if person.hashed_password == "#{hashed_password}#{person.salt}"
      timing "Changing old style password to new password"
      person.change_password(password, password)
      return_val = person
    else
      return_val = nil
    end unless person.nil?
    return_val
  end
  
  # Generates a unique hash value for the user 
  def set_login_cookie!
    # hash the user's email address and a salt
    self.login_token = Person.hash_password("#{self.email}#{Person.random_password}")
    self.save!
    return self.login_token
  end
  
  def change_password(old_pass, new_pass)
    verified = (self.hashed_password == "#{Person.hash_password(old_pass)}#{self.salt}") || (self.hashed_password == Person.hash_password("#{old_pass}#{self.salt}"))
    if verified
      self.hashed_password = Person.hash_password("#{new_pass}#{self.salt}")
      self.needs_reset = false
      self.save
    end
    return verified
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
    self.all_locations.last || Location.new(SAMPLE_LOCATION)
  end
  
  def current_location
    changes_list = self.changes.clone
    main_location = changes_list.delete_if {|change| change.change_type != Change::PERSON_MAIN_LOCATION }.sort { |x,y| x.effective_date <=> y.effective_date }.collect! {|c| Location.find(c.new_value) unless c.new_value.nil?}.last
    if (main_location.nil? || main_location.empty?)
      main_location = self.latest_location
    end
    main_location
  end
  
  def main_location
    self.current_location
  end
  
  def all_locations
    changes_list = self.changes.clone
    all_locations = changes_list.delete_if {|change| ((change.change_type == Change::OWNERSHIP) || (change.change_type == Change::ITEM_LOCATION))}
    all_locations.sort {|x,y| x.effective_date <=> y.effective_date}
    all_locations.collect! {|c| Location.find(c.new_value) unless c.new_value.nil?}.uniq
  end
  
  def all_location_options
    self.all_locations.collect {|l| [l.description, l.id]}
  end
  
  # remove the association with this location
  def remove_location(location)
    changes_list = self.changes.clone
    all_location_changes = changes_list.delete_if {|change| ((change.change_type == Change::OWNERSHIP) || (change.change_type == Change::ITEM_LOCATION))}
    all_location_changes.each {|c| c.destroy if (c.new_value.to_s == location.id.to_s && location.class == Location) }
  end
  
  # change the active location if someone or something else is using old_location
  # to do this, replace old_location with new_location in the change that added old_location
  # also, new_location needs to be saved to the database
  def swap_locations(old_location, new_location)
    changes_list = self.changes.clone
    all_location_changes = changes_list.delete_if {|change| ((change.change_type == Change::OWNERSHIP) || (change.change_type == Change::ITEM_LOCATION))}
    all_location_changes.each do |change|
      if change.new_value.to_s == old_location.id.to_s
        change.new_value = new_location.id
        change.save!
      end
    end
  end
  
  def change_location(new_location, date = Time.now)
    change = Change.new
    change.change_type = Change::PERSON_LOCATION
    change.old_value = self.latest_location.id unless self.latest_location.nil?
    change.new_value = new_location.id
    change.effective_date = date
    change.person_id = self.id
    change.save
    self.changes << change
    change.save
#    self.locations << new_location
#    self.save!
  end
  
  def set_main_location(new_location, date = Time.now)
    change = Change.new
    change.change_type = Change::PERSON_MAIN_LOCATION
    change.old_value = self.current_location.id unless self.current_location.nil?
    change.new_value = new_location.id
    change.effective_date = date
    change.person_id = self.id
    change.save
    self.changes << change
    change.save
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
  
  def is_friend?(person)
    person = Person.find(person) unless person.kind_of?(Person)
    if self.friends.include?(person) || self == person # You are friends with yourself :)
      return true
    else
      return false
    end
  end
  
  def add_friend(friend_id)
#    timing "Adding friend for person ids #{self.id} and #{friend_id}"
    @friend = Friend.new
    @friend.owner_person_id = self.id
    @friend.entry_person_id = friend_id
    @friend.permissions = "rwrwrw"
    @friend.save
    @friend.create_symmetrical
  end
  
  def map_icon
    thumb = self.main_photo.thumb_url(18)
    if thumb == self.main_photo.url
      return '/images/personicon.png'
    else
      return thumb
    end
  end
  
  def self.titles
    titles = ["", "Mr.", "Mrs.", "Ms."]
  end
  
  def self.suffixes
    suffixes = ["", "Sr.", "Jr.", "III"]
  end
  
  def send_reset_email(password = Person.random_password)
    self.reset_password(password)
    UserMailer.deliver_retrieve(self, password)
  end
  
  def reset_password(new_password = Person.random_password)
    self.hashed_password = Person.hash_password("#{new_password}#{self.salt}")
    self.needs_reset = true
    self.save!
  end
  
  # Generates a random 8 character hex password
  def self.random_password
    Digest::SHA2.hexdigest(Time.now.to_s)[10..18]
  end

  private
  def self.hash_password(password)
    main = Digest::SHA2.hexdigest(password)
  end
  
  def remove_all_messages
    self.messages.each {|message| message.delete_by(self.id)}
  end

end
