class UserMailer < ActionMailer::Base
  default :from => 'TravellerBooks <do-not-reply@travellerbook.com>'

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @recipients = person.email
    @sent_on    = sent_at
    @temp_pass  = password
  end

  def welcome(person, sent_at = Time.now)
#    css 'html-mail'
    @subject    = 'Welcome to TravellerBook.com'
    @recipients = person.email
    @sent_on    = sent_at
    @person     = person
  end
  
  def friend_request(person, friend, sent_at = Time.now)
    @subject    = 'You have a friend request at TravellerBook.com'
    @body       = {:friend => friend, :person => person}
    @recipients = person.email
    @sent_on    = sent_at
    @headers    = {}
    @person     = person
    @friend     = friend
  end
  
  def invitation(message, recipient, sent_at = Time.now)
#    css 'html-mail'
    @subject    = message.subject
    @body       = message.body
    @recipient  = recipient
    @sent_on    = sent_at
    @headers    = {}
    @friend     = message.sender_p
    @message    = message
  end
  
  def notification(person, message, sent_at = Time.now)
    @subject    = message.subject
    @body       = message.body
    @recipients = message.parse_recipients.join(',')
    @sent_on    = sent_at
    @headers    = {}
    @person     = person
  end
end
