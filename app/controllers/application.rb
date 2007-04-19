# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  private
  
  # Makes sure the user is logged in and has a session before displaying certain pages
  def authorize
    if (session[:user_id].nil? || session[:user_id] == "")
      redirect_to :controller => 'user', :action => 'login'
      return
    end
  end
end