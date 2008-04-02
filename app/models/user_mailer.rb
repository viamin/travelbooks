class UserMailer < ActionMailer::ARMailer

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @body       = {:person => person, :temp_pass => password}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end

  def welcome(person, sent_at = Time.now)
    @subject    = 'Welcome to TravellerBook.com'
    @body       = {:person => person}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
  
  def friend_request(person, friend, sent_at = Time.now)
    @subject    = 'You have a friend request at TravellerBook.com'
    @body       = {:friend => friend, :person => person}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
  
end
