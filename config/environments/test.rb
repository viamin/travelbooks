# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

config.log_level = :debug

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Put caches somewhere I can find them
ActionController::Base.cache_store = :file_store, "public/fragment_caches/"

# Person id of the "Nobody" user, where given away books stay
NOBODY_USER = 5

# To workaround http://rails.lighthouseapp.com/projects/8994/tickets/1453-gets-in-integration-test-unless-you-are-using-cookie-sessions
# From http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/5519ca7fd4dde3c1
class ActionController::RackRequest 
    DEFAULT_SESSION_OPTIONS = { 
      :database_manager => CGI::Session::ActiveRecordStore, 
      :cookie_only      => false, 
      :session_http_only=> true 
    } 
end