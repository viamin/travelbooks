# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

config.log_level = :debug

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Person id of the "Nobody" user, where given away books stay
NOBODY_USER = 5

# Put caches somewhere I can find them
ActionController::Base.cache_store = :file_store, "public/fragment_caches/"

# To use ar_mailer, the following line must be uncommented
ActionMailer::Base.delivery_method = :activerecord
# Should be safe to perform deliveries since they just get dumped to a database
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true  
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => 'localhost',
  :port => 8025,
  :authentication => :login,
  :domain => 'elguapo.homedns.org',
  :user_name => '',
  :password => ''
}