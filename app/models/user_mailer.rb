class UserMailer < ActionMailer::ARMailer

  def retrieve(person, password, sent_at = Time.now)
    @subject    = 'Your TravellerBook.com password has been reset'
    @recipients = person.email
    @from       = 'TravellerBooks <do-not-reply@travellerbook.com>'
    @sent_on    = sent_at
    content_type "multipart/alternative"
    @temp_pass = password
    part :content_type => "text/plain" do |p|
      p.body = render_message("retreive.text.plain.erb")
      p.transfer_encoding = "8bit"
    end

    part :content_type => "multipart/related" do |p|
        p.parts.unshift ActionMailer::Part.new(
          :content_type => "text/html", :body => render_message("retrieve.text.html.erb", :part_container => p),
          :disposition => "",
          :charset => "UTF-8",
          :transfer_encoding => "8bit"
        )
    end
  end

  def welcome(person, sent_at = Time.now)
    layout 'html-mail'
    css ['reset-fonts-grids', 'main']
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
def build_status(sender, train, html_summary, destination, builds, releases, hitlist, perf_hitlist)
  email_subject = Time.now.strftime("#{train.name} Build Status - %m/%d/%Y")

  # Standard ActionMailer configuration methods
#    recipients("Leopard Announce <leopard-announce@group.apple.com>")
  recipients(destination)
  headers('Reply-to' => "Mac OS X Program Office <macosx-program@group.apple.com>")
  from(sender)
  subject(email_subject)
  content_type "multipart/alternative"
  
  part :content_type => "text/plain" do |p|
    p.body = render_message("build_status.text.plain.erb", :html_summary => html_summary, :subject => email_subject, :builds => builds, :releases => releases, :hitlist => hitlist, :perf_hitlist => perf_hitlist, :train => train)
    p.transfer_encoding = "8bit"
  end
  
  part :content_type => "multipart/related" do |p|
      p.parts.unshift ActionMailer::Part.new(
        :content_type => "text/html", :body => render_message("build_status.text.html.erb", :html_summary => html_summary, :subject => email_subject, :builds => builds, :releases => releases, :hitlist => hitlist, :perf_hitlist => perf_hitlist, :train => train, :part_container => p),
        :disposition => "",
        :charset => "UTF-8",
        :transfer_encoding => "8bit"
      )
  end
  
end
=end