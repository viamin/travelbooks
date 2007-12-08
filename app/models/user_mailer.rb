class UserMailer < ActionMailer::Base

  def retrieve(sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end

  def welcome(sent_at = Time.now)
    @subject    = 'Welcome to TravellerBook.com'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
end
