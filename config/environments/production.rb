# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

#ENV['GEM_HOME'] = '/usr/local/lib/ruby/gems-dev/1.8'

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.server_settings = { 
:address => "mail.travellerbook.com", 
:port => 465, 
:domain => "travellerbook.com", 
:authentication => :login, 
:user_name => "do-not-reply+travellerbook.com", 
:password => "/1<$xFMp!-k-", 
} 

# Person id of the "Nobody" user, where given away books stay
NOBODY_USER = 2