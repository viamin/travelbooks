require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Travelbooks
  class Application < Rails::Application
    # Settings in config/environments/* take precedence those specified here
    
    # Skip frameworks you're not going to use (only works if using vendor/rails)
    # config.frameworks -= [ :action_web_service ]
  
    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{Rails.root}/app/sweepers )
  
    # Force all environments to use the same logger level 
    # (by default production uses :info, the others :debug)
    # config.log_level = :warn
      
    # Use SQL instead of Active Record's schema dumper when creating the test database.
    # This is necessary if your schema can't be completely dumped by the schema dumper, 
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql
    
    # Load awesome_email plugin last
    #config.plugins = [ :all, :awesome_email ] 
      
    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector
      
    # Make Active Record use UTC-base instead of local time
    # config.active_record.default_timezone = :utc
    
    # See Rails::Configuration for more options
    config.filter_parameters << :password
  end
  
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
  ENV['TMPDIR'] = "#{Rails.root}/public/images/tmp"
  ENV['TEMP'] = "#{Rails.root}/public/images/tmp"
  ENV['TMP'] = "#{Rails.root}/public/images/tmp"
  APPLICATION_ERROR_EMAIL = "support@travellerbook.com"
  MAP_TYPE = :yahoo
  
end

Time::DATE_FORMATS[:last_login_time] = "%l:%M%p"
Time::DATE_FORMATS[:last_login] = "%l:%M%p %b %e"

class Array
  # Return a hash from a nested array. The inverse of taking a hash and calling to_a on it
  def to_h
    if self.length == 0
      return self
    end
    if self.length != (self.flatten.length / 2)
      return {}
    end
    ret_hash = Hash.new
    self.each do |suba|
      ret_hash[suba[0]] = suba[1]
    end
    ret_hash
  end
end

def timing(str)
  time = Time.now
  string = "[#{time.strftime "%H:%M:%S"}-#{ (time.usec / 1000).to_s.rjust(3,"0") }] #{str}"
  Rails.logger.info string unless ENV['RAILS_ENV'] == 'production'
end