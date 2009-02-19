#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  config.frameworks -= [ :action_web_service ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  config.log_level = :warn

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
#  config.action_controller.session = { :session_key => "_tb_session", :secret => "this_is_not_a_secret" }

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  config.gem "hoe"
  config.gem "hpricot"
  config.gem "rmagick"
  config.gem "ar_mailer", :lib => "action_mailer/ar_mailer"
  config.gem "csspool"
  config.gem "inline_attachment"
  
  # Load awesome_email plugin last
  #config.plugins = [ :all, :awesome_email ] 

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
=begin
require 'action_mailer/ar_mailer'
#require "#{RAILS_ROOT}/vendor/rmagick-2.9.1/lib/RMagick.rb"
require 'rmagick'
include Magick
#require "#{RAILS_ROOT}/vendor/csspool-0.2.6/lib/csspool.rb"
require 'csspool'
=end
require 'pp'
include Magick

# How many differences does a location need before creating a new location and change?
DIFFERENCE_THRESHOLD = 1

# Replace this after every presidential election
SAMPLE_PERSON = { :nickname => "B. Obama",
                  :birthday => Time.local(1961, 8, 4) }

SAMPLE_LOCATION = { :address_line_1 => "1600 Pennsylvania Ave.",
                    :city => "Washington",
                    :description => "The White House",
                    :state => "DC",
                    :country => "USA",
                    :zip_code => "20006",
                    :lat => 38.89859,
                    :lng => -77.035971 }

COLORS = ['#fff', '#633c1f', '#394876', '#2f4380', '#ffe7a5', '#000']
ENV['TMPDIR'] = "#{RAILS_ROOT}/public/images/tmp"
ENV['TEMP'] = "#{RAILS_ROOT}/public/images/tmp"
ENV['TMP'] = "#{RAILS_ROOT}/public/images/tmp"
APPLICATION_ERROR_EMAIL = "support@travellerbook.com"
MAP_TYPE = :yahoo

def timing(str)
  time = Time.now
  string = "[#{time.strftime "%H:%M:%S"}-#{ (time.usec / 1000).to_s.rjust(3,"0") }] #{str}"
  RAILS_DEFAULT_LOGGER.info string unless ENV['RAILS_ENV'] == 'production'
end

ExceptionNotifier.exception_recipients = %w( support@travellerbook.com )
ExceptionNotifier.sender_address = %("TravellerBook Application Error" <do-not-reply@travellerbook.com>)

Time::DATE_FORMATS[:last_login_time] = "%l:%M%p"
Time::DATE_FORMATS[:last_login] = "%l:%M%p %b %e"

# These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
GeoKit::default_units = :miles
GeoKit::default_formula = :sphere

# This is the timeout value in seconds to be used for calls to the geocoder web
# services.  For no timeout at all, comment out the setting.  The timeout unit
# is in seconds. 
GeoKit::Geocoders::timeout = 3

# These settings are used if web service calls must be routed through a proxy.
# These setting can be nil if not needed, otherwise, addr and port must be 
# filled in at a minimum.  If the proxy requires authentication, the username
# and password can be provided as well.
GeoKit::Geocoders::proxy_addr = nil
GeoKit::Geocoders::proxy_port = nil
GeoKit::Geocoders::proxy_user = nil
GeoKit::Geocoders::proxy_pass = nil

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
GeoKit::Geocoders::yahoo = 'travellerbooks'
    
# This is your Google Maps geocoder key. 
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
GeoKit::Geocoders::google = 'REPLACE_WITH_YOUR_GOOGLE_KEY'
    
# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
GeoKit::Geocoders::geocoder_us = false 

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For 
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
GeoKit::Geocoders::geocoder_ca = false

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the 
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
GeoKit::Geocoders::provider_order = [:yahoo,:google]
