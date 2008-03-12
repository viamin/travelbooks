# Error informs the address contained by APPLICATION_ERROR_EMAIL (defined in config/environment.rb) when application errors occur.

class Error < ActionMailer::Base
  
  # Sends a email detailing the given exception. 
  def warn(exception, trace, session, params, env, sent_on = Time.now)
    @person = Person.find(session[:user_id]) unless session[:user_id].nil? || session[:user_id].empty?
    @subject    = "TravellerBook.com had a problem: #{exception.message}"
    @body       = { :exception => exception }
    @recipients = APPLICATION_ERROR_EMAIL
    @from       = "TravellerBook.com errors <support@travellerbook.com>"
  end

end