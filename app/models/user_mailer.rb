class UserMailer < ActionMailer::ARMailer

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @body       = {:person => person, :temp_pass => password}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end

  def welcome(sent_at = Time.now)
    @subject    = 'Welcome to TravellerBook.com'
    @body       = {}
    @recipients = ''
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
end
