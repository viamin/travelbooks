# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '1.1.6'
ENV['GEM_HOME'] = '/usr/local/lib/ruby/gems-dev/1.8'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  config.action_controller.session = { :session_key => "_tb_session", :secret => "this_is_not_a_secret" }

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

def timing(str)
  time = Time.now
  string = "[#{time.strftime "%H:%M:%S"}-#{ (time.usec / 1000).to_s.rjust(3,"0") }] #{str}"
  RAILS_DEFAULT_LOGGER.info string
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

# How many differences does a location need before creating a new location and change?
DIFFERENCE_THRESHOLD = 1

# Replace this after every presidential election
SAMPLE_PERSON = { :first_name => "George W.",
                  :birthday => Time.local(1946, 7, 6) }

SAMPLE_LOCATION = { :address_line_1 => "1600 Pennsylvania Ave.",
                    :city => "Washington",
                    :state => "DC",
                    :country => "USA" }
                    
require 'pp'

=begin
############################# 
# This needs to be added because 'pretty_inspect' only works with Ruby 1.8.5, but Tiger ships with Ruby 1.8.4
module Kernel
  def pretty_inspect
    PP.pp(self, '')
  end
end
=end