class UserMailer < ActionMailer::ARMailer

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    content_type "multipart/alternative"
    
    part :content_type => "text/plain" do |p|
      p.body = render_message("retrieve.text.plain.erb", :temp_pass => password)
      p.transfer_encoding = "8bit"
    end
    
    part :content_type => "multipart/related" do |p|
	      p.parts.unshift ActionMailer::Part.new(
	        :content_type => "text/html", :body => render_message("retreve.text.html.erb", :temp_pass => password, :part_container => p),
	        :disposition => "",
	        :charset => "UTF-8",
	        :transfer_encoding => "8bit"
	      )
	  end
  end

  def welcome(person, sent_at = Time.now)
    @subject    = 'Welcome to TravellerBook.com'
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    content_type "multipart/alternative"
    
    part :content_type => "text/plain" do |p|
      p.body = render_message("welcome.text.plain.erb", :person => person)
      p.transfer_encoding = "8bit"
    end
    
    part :content_type => "multipart/related" do |p|
	      p.parts.unshift ActionMailer::Part.new(
	        :content_type => "text/html", :person => person, :body => render_message("welcome.text.html.erb", :part_container => p),
	        :disposition => "",
	        :charset => "UTF-8",
	        :transfer_encoding => "8bit"
	      )
	  end
  end
  
  def friend_request(person, friend, sent_at = Time.now)
    @subject    = 'You have a friend request at TravellerBook.com'
    @body       = {:friend => friend, :person => person}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
  
  def invitation(message, sent_at = Time.now)
    @subject    = message.subject
    @body       = message.body
    @recipients = message.parse_recipients.join(',')
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
  
  def notification(person, message, sent_at = Time.now)
    @subject    = message.subject
    @body       = message.body
    @recipients = message.parse_recipients.join(',')
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
  end
end

=begin
recipients(destination)
headers('Reply-to' => "Mac OS X Program Office <macosx-program@group.apple.com>")
from(sender)
subject(email_subject)
=end