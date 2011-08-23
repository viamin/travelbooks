class UserMailer < ActionMailer::Base
  default :from => 'TravellerBooks <do-not-reply@travellerbook.com>'

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    # @sent_on    = sent_at
    @temp_pass  = password
    mail(:to => person.email, :subject => @subject)
  end

  def welcome(person, sent_at = Time.now)
    @subject    = 'Welcome to TravellerBook.com'
    # @sent_on    = sent_at
    @person     = person
    mail(:to => person.email, :subject => @subject)
  end
  
  def friend_request(person, friend, sent_at = Time.now)
    @subject    = 'You have a friend request at TravellerBook.com'
    # @sent_on    = sent_at
    # @person     = person
    @friend     = friend
    mail(:to => person.email, :subject => @subject)
  end
  
  def invitation(message, recipient, sent_at = Time.now)
    @subject    = message.subject
    @body       = message.body
    @recipient  = recipient
    # @sent_on    = sent_at
    @friend     = message.sender_p
    @message    = message
    mail(:to => recipient, :subject => @subject)
  end
  
  def notification(person, message, sent_at = Time.now)
    @subject    = message.subject
    @body       = message.body
    @recipients = message.parse_recipients.join(',')
    # @sent_on    = sent_at
    @person     = person
    mail(:to => @recipients, :subject => @subject)
  end
end
