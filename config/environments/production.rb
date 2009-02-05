# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

#ENV['RAILS_GEM_VERSION'] = "2.2.2"

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = false   # NEED TO GET THIS WORKING

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# To use ar_mailer, the following line must be uncommented
ActionMailer::Base.delivery_method = :activerecord
ActionMailer::Base.perform_deliveries = true  
ActionMailer::Base.raise_delivery_errors = true  
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => 'mail.travellerbook.com',
  :port => 26,
  :authentication => :login,
  :user_name => 'do-not-reply+travellerbook.com',
  :password => 'WD,359rL-S&f'
}

# Person id of the "Nobody" user, where given away books stay
NOBODY_USER = 2
