class UserMailer < ActionMailer::ARMailer

  def retrieve(person, password, sent_at = Time.now)
    layout 'user_mailer'
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
          :content_type => "text/html", :body => render_message("retrieve.text.html.erb", :temp_pass => password, :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end

  def welcome(person, sent_at = Time.now)
    layout 'user_mailer'
#    css 'html-mail'
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
          :content_type => "text/html", :body => render_message("welcome.text.html.erb", :person => person, :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end
  
  def friend_request(person, friend, sent_at = Time.now)
    layout 'user_mailer'
    @subject    = 'You have a friend request at TravellerBook.com'
    @body       = {:friend => friend, :person => person}
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
    
    content_type "multipart/alternative"
    
    part :content_type => "text/plain" do |p|
      p.body = render_message("friend_request.text.plain.erb", :person => person, :friend => friend)
      p.transfer_encoding = "8bit"
    end

    part :content_type => "multipart/related" do |p|
        p.parts.unshift ActionMailer::Part.new(
          :content_type => "text/html", :body => render_message("friend_request.text.html.erb", :person => person, :friend => friend, :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end
  
  def invitation(message, recipient, sent_at = Time.now)
    layout 'user_mailer'
#    css 'html-mail'
    @subject    = message.subject
    @body       = message.body
    @recipients = recipient
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
    content_type "multipart/alternative"
    
    part :content_type => "text/plain" do |p|
      p.body = render_message("invitation.text.plain.erb", :recipient => recipient, :friend => message.sender_p, :message => message)
      p.transfer_encoding = "8bit"
    end

    part :content_type => "multipart/related" do |p|
        p.parts.unshift ActionMailer::Part.new(
          :content_type => "text/html", :body => render_message("invitation.text.html.erb", :recipient => recipient, :friend => message.sender_p, :message => message, :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end
  
  def notification(person, message, sent_at = Time.now)
    layout 'user_mailer'
    @subject    = message.subject
    @body       = message.body
    @recipients = message.parse_recipients.join(',')
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    @headers    = {}
    content_type "multipart/alternative"
    
    part :content_type => "text/plain" do |p|
      p.body = render_message("notification.text.plain.erb", :person => person)
      p.transfer_encoding = "8bit"
    end

    part :content_type => "multipart/related" do |p|
        p.parts.unshift ActionMailer::Part.new(
          :content_type => "text/html", :body => render_message("notification.text.html.erb", :person => person, :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end
end
