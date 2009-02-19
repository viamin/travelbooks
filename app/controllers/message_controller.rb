class MessageController < ApplicationController
  before_filter :authorize, :except => [:invitation]
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @person = Person.find(session[:user_id])
    @messages = @person.messages.inbox
  end
  
  def sent
    @person = Person.find(session[:user_id])
    @messages = @person.sent_messages
    @no_reply = true
  end
  
  def show
    @message = Message.find(params[:id])
    if @message.message_type == Message::FRIENDREQUEST
      redirect_to :action => 'show_request', :id => @message.id
      return
    end
    @message.mark_read
    @message.body.gsub!("\n", "<br />")
    @sender = @message.sender_p
    @no_reply = (@sender.id == session[:user_id])
  end
  
  def show_request
    @message = Message.find(params[:id])
    @sender = @message.sender_p
  end
  
  def new
    @sender = Person.find(session[:user_id])
    @recipient = Person.find(params[:id]) if params[:id]
    params[:sent_at].nil? ? sent_at = String.new : sent_at = params[:sent_at]
    @friends = @sender.friends.collect!{|f| [f.display_name, f.id] }
    @friends.concat([[@recipient.display_name, @recipient.id]]) unless @recipient.nil?
    if params[:message_id] # is a reply
      @reply_to = Message.find(params[:message_id])
      @reply_to.mark_replied!
      reply_to_name = Person.find(@reply_to.sender).display_name
      @reply_to.subject = "Re: #{@reply_to.subject}" unless @reply_to.subject =~ /^Re:/
    else
      @reply_to = Message.new
      @reply_to.sender = params[:id] if params[:id]
      reply_to_name = String.new
    end
    # since @reply_to expects the message to be a reply, reverse sender and person_id meanings
    # I know, it's lame...
#    @reply_to = Message.new({:sender => params[:id]}) if params[:id]
    @reply_to.body = @reply_to.reply_body(reply_to, sent_at) if @reply_to.body && @reply_to.body.length > 0
  end
  
  def create
    @person = Person.find(session[:user_id])
    unless params[:commit] == "Cancel"
      @message = Message.new(params[:message])
      @message.sender = @person.id
      @message.state = 0
      if @message.save
        flash[:notice] = "Your message has been sent to #{Person.find(@message.person_id).display_name}"
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
    else
      redirect_to :action => 'list'
    end
  end
  
  def delete
    @message = Message.find(params[:id])
    @message.delete_by(session[:user_id])
    if session[:last_action] == "message_sent"
      redirect_to :action => 'sent'
    else
      redirect_to :action => 'list'
    end
  end
  
  def post
    redirect_to :action => 'list'
    return
    @sender = Person.find(session[:user_id])
    @reply_to = Message.new
  end
  
  def post
    
  end
  
  def invite
    @person = Person.find(session[:user_id])
    @message = Message.new(:message_type => Message::INVITATION, :sender => @person.id, :subject => "#{@person.display_name} has invited you to join TravellerBook.com")
  end
  
  def send_invites
    @message = Message.create(params[:message])
    @count = 0
    @message.parse_recipients.each do |r|
      # first make sure the emails aren't already in the system as existing users and already friends
      person = Person.find_by_email(r)
      if person.kind_of?(Person)
        unless @message.sender_p.is_friend?(person)
          Message.send_request(@message.sender_p, person)
          @count = @count + 1
        end
      else
        UserMailer.deliver_invitation(@message, r)
        @count = @count + 1
      end
    end
    flash[:notice] = "Your invitation has been sent to #{pluralize(@count, 'person')}"
    redirect_to :action => 'invite'
  end
  
  def invitation
    @needs_search = true
    unless (params[:id].nil? || params[:email].nil?)
      @message = Message.find(:first, :conditions => {:id => params[:id]})
      @needs_search = false unless (@message.nil? || @message.is_read?)
    end
    @person = Person.new
    @person.email = params[:email] unless params[:email].nil?
  end
  
  def test
    @person = Person.find(session[:user_id])
#    render :text => "<pre>#{UserMailer.create_welcome(@person)}</pre>", :layout => false
    @message = Message.new(:message_type => Message::INVITATION, :sender => @person.id, :subject => "#{@person.display_name} has invited you to join TravellerBook.com")
    render :text => "<pre>#{UserMailer.create_invitation(@message, "fake@person.com")}</pre>", :layout => false
  end
  
end
