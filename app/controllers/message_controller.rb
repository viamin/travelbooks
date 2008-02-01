class MessageController < ApplicationController
  before_filter :authorize
  
  def index
    redirect_to :action => 'home'
  end
  
  def list
    @person = Person.find(session[:user_id])
    @messages = @person.messages.inbox
  end
  
  def sent
    @person = Person.find(session[:user_id])
    @messages = @person.sent_messages
  end
  
  def show
    @message = Message.find(params[:id])
    if @message.message_type == Message::FRIENDREQUEST
      redirect_to :action => 'show_request', :id => @message.id
    end
    @message.mark_read
    @sender = @message.sender_p
    @no_reply = (@sender.id == session[:user_id])
  end
  
  def show_request
    @message = Message.find(params[:id])
    @sender = @message.sender_p
  end
  
  def new
    @sender = Person.find(session[:user_id])
    @friends = @sender.friends.collect!{|f| [f.display_name, f.id] }
    if params[:message_id]
      @reply_to = Message.find(params[:message_id])
      @reply_to.subject = "Re: #{@reply_to.subject}" unless @reply_to.subject =~ /^Re:/
    else
      @reply_to = Message.new
    end
    # since @reply_to expects the message to be a reply, reverse sender and person_id meanings
    # I know, it's lame...
    @reply_to = Message.new({:sender => params[:id]}) if params[:id]
  end
  
  def create
    @person = Person.find(session[:user_id])
    unless params[:commit] == "Cancel"
      @message = Message.new(params[:message])
      @message.sender = @person.id
      @message.save!
      flash[:notice] = "Your message has been sent to #{Person.find(@message.person_id).display_name}"
    end
    redirect_to :action => 'list'
  end
  
end
