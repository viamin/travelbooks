class UsersController < ApplicationController
  before_filter :check_cookie
  before_filter :authorize, :except => [:login, :join, :retrieve, :mark_friends, :mark_items, :iforgot]
  after_filter :set_login_cookie, :only => [:login]
  after_filter :delete_login_cookie, :only => [:logout]
  layout 'user', :except => 'user_stats'
#  caches_action :home
  cache_sweeper :friend_sweeper, :only => [:accept]
  
  def index
    redirect_to :action => 'home'
  end

  def list
    @person = Person.find(params[:id])
    @location = @person.current_location
    @friends = @person.friends
    # @map = Mapstraction.new("friend_map", MAP_TYPE)
    # @map.control_init(:small => true)
    # @map.center_zoom_init([@location.lat, @location.lng],10)
    # @map.marker_init(Marker.new([@location.lat, @location.lng], :icon => '/images/homeicon.png'))
    @json = @location.to_gmaps4rails
  	@friends.each do |f|
  	  fl = f.current_location
  	  # @map.marker_init(Marker.new([fl.lat, fl.lng], :info_bubble => f.display_name, :icon => f.map_icon))
	  end
  end

  def show
    if (params[:id].to_i == session[:user_id].to_i)
      redirect_to :action => 'home'
      return
    end
    @person = Person.find(params[:id])
    if @person.private_profile
       # @map = Mapstraction.new('user_map', MAP_TYPE)
       #  @map.control_init(:small => true)
      @location = Location.default
        # @map.center_zoom_init([@location.lat, @location.lng], 12)
#        @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @person.display_name, :icon => '/images/personicon.png'))
      @json = @location.to_gmaps4rails
      render :action => 'private', :layout => false
      return
    end
    @me = Person.find(session[:user_id])
    @location = @person.current_location
    unless read_fragment(:controller => 'user', :action => 'show', :action_suffix => "items#{@person.id}")
      @items = @person.items
    end
    unless read_fragment(:controller => 'user', :action => 'show', :action_suffix => "friends#{@person.id}")
      @friends = @person.friends
      @is_my_friend = @friends.include?(@me)
    end
    unless @is_my_friend
      @is_my_friend = Message.check_for_request(@me, @person)
    end
    unless (read_fragment(:controller => 'user', :action => 'show', :action_suffix => "map#{@person.id}"))
      # @map = Mapstraction.new('user_map', MAP_TYPE)
      # @map.control_init(:small => true)
      # @map.center_zoom_init([@location.lat, @location.lng], 10)
      # @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @person.display_name, :icon => '/images/personicon.png'))
      @json = @location.to_gmaps4rails
    end
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  # Only allow logged in user's profile to be edited by using session - no user input will be taken
  def edit
    @person = Person.find(session[:user_id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      render :action => 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def home
#    timing session.pretty_inspect
    unless session[:last_action] == "user_home"
      case session[:last_action]
      when "item_associate"
        unless session[:item_last_viewed].nil?
          redirect_to :controller => 'item', :action => 'associate', :id => session[:item_last_viewed]
        end
      end
    end
    @person = Person.find(session[:user_id]) unless session[:user_id].nil?
    if @person.nil?
      redirect_to :action => 'login'
    else
      @new_messages = @person.messages.unread
      flash[:notice] = "#{flash[:notice].concat('<br />') if flash[:notice]}You have #{@new_messages.length} unread message#{"s" if @new_messages.length > 1} in your <a href=\"/message/list\">inbox</a>." unless session[:settled_in] || @new_messages.empty?
      
      # Item section
      unless read_fragment(:controller => 'user', :action => 'home', :action_suffix => "items#{@person.id}")
        @items = @person.items
        @list_all_items = false
        if @items.empty?
          @items = @person.all_items
          @list_all_items = true
        end
      end
      
      # friends section
      unless read_fragment(:controller => 'user', :action => 'home', :action_suffix => "friends#{@person.id}")
        @friends = @person.friends
      end
      
      # Map section
      @location = @person.current_location
      unless (read_fragment(:controller => 'user', :action => 'home', :action_suffix => "map#{@person.id}"))
        @locations = @person.all_locations
        # @map = Mapstraction.new('user_map', MAP_TYPE)
        # @map.control_init(:small => true)
        # @map.center_zoom_init([@location.lat, @location.lng], 10)
        # @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @location.description, :icon => '/images/homeicon.png'))
        @json = @location.to_gmaps4rails
        @locations.each do |l|
          unless l == @location
            # @map.marker_init(Marker.new([l.lat, l.lng], :info_bubble => l.description))
          end
        end
      end
      session[:settled_in] = true
    end
  end  
  
  def login
    unless session[:user_id].nil?
      flash[:notice] = "You are already logged in with a TravellerBook.com account. If you'd like to create a new account, please log out first by clicking the 'Logout' link above."
      redirect_to :action => 'home'
      return
    end
    @login_status = nil
    if params[:person] && Person.is_valid_login?(params[:person][:email])
      unless request.get?
        @person = Person.email_login(params[:person][:email], params[:person][:password])
        if @person.kind_of?(Person)
          session[:user_id] = @person.id
          session[:user_email] = @person.email
          @person.last_login = Time.now
          @person.save!
          @login_status = :success
          next_action = :redirect
        else
          flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
          @login_status = :failed
          next_action = :redirect
        end
        if next_action == :redirect
          if @login_status == :success
            if @person.needs_reset == true
              flash[:notice] = "Your password was recently reset. You will need to enter a new password in order to log in next time."
              redirect_to :action => 'reset_password', :temp_pass => params[:person][:password], :id => @person.id
              return
            else
              session[:settled_in] = nil
              redirect_to :action => "home"
              return
            end
          else
            redirect_to :action => 'login'
            return
          end
        end
      end
    elsif params[:person].nil?
      # use flash from redirect
    else
      flash[:notice] = "Sorry, the username you entered does not match with any registered users."
    end
  end
  
  def logout
    reset_session
    redirect_to :controller => 'main', :action => 'index'
  end
  
  def retrieve
  end
  
  def iforgot
    if (params.nil? || params.empty? || params[:retrieve].nil? || params[:retrieve].empty?)
      redirect_to :action => 'retrieve'
      return
    else
      @person = Person.where({:email => params[:retrieve][:email_address]}).first
      if @person.nil?
        flash[:notice] = "There was no user found with that email address."
        render :action => 'retrieve'
      else
        @person.send_reset_email
      end
    end
  end

  def join
    unless session[:user_id].nil?
      flash[:notice] = "You are already logged in with a TravellerBook.com account. If you'd like to create a new account, please log out first by clicking the 'Logout' link above."
      redirect_to :action => 'home'
    end
    if request.get?
#      timing "Path 1 (Request method: GET)"
      @person = Person.new
      @location = Location.new
    else
#      timing "Path 2 (Request method: POST)"
      @person = Person.new(params[:person])
      @location = Location.new(params[:location])
      @location.loc_type = 1
      if @location.has_good_info?
        @location.person = @person
        @person.last_login = Time.now
   # Change this to put the @person and @location saves in a transaction to make sure both of them go through or none. 
        if @person.save
          if @location.has_good_info? && @location.save!
            @person.changes.create( :location => @location, :person => @person, :effective_date => Time.now, :change_type => Change::PERSON_LOCATION, :new_value => @location.id.to_s)
          end
          flash[:notice] = "Thank you for joining TravellerBook.com."
          UserMailer.welcome(@person).deliver
          session[:user_id] = @person.id
          unless params[:id].nil?
            # Should mean this is a join due to an invitation
            message = Message.where({:id => params[:id]}).first
            message.complete_invitation!(@person) unless message.nil?
          end
          redirect_to :action => :home
        else
          flash[:notice] = "Sorry, there was a problem creating your account."
          render :action => :join
        end
      else
        flash[:notice] = "There was a problem creating your account. The address or location you entered is giving us problems."
        render :action => :join
      end
    end
  end
  
  def mark_friends
    @person = Person.find(params[:id])
    @friends_loc = @person.friends.collect {|f| f.current_location }
    @center = find_center(@friends_loc)
    width, height = params[:width], params[:height]
    @zoom = best_zoom(@friends_loc, @center, width, height)
    # @map = Variable.new("map")
  end
  
  def mark_items
    @person = Person.find(params[:id])
    @items_loc = @person.all_items.collect {|i| i.locations.current }
    @center = find_center(@items_loc)
    width, height = params[:width], params[:height]
    @zoom = best_zoom(@items_loc, @center, width, height)
    # @map = Variable.new("map")
  end
  
  def show_trips
    @person = Person.find(params[:id])
    if @person.share_trips
      @trips = @person.trips
    else
      @trips = [Trip.new]
    end
    # @map = Variable.new("map")
  end
  
  def add
    @person = Person.find(session[:user_id])
    @friend = Person.find(params[:id]) unless params[:id].nil?
    if @friend.nil?
      flash[:notice] = "There was an error adding that person"
      redirect_to :action => 'home'
    end
  end
  
  def send_request
    @person = Person.find(session[:user_id])
    @friend = Person.find(params[:friend_id])
    if params[:commit] == "Confirm"
      flash[:notice] = "A message has been sent to <a href=\"/user/show/#{@friend.id}\">#{@friend.display_name}</a>."
      Message.send_request(@person, @friend)
    end
    redirect_to :action => 'show', :id => @friend.id
  end
  
  def accept
    @message = Message.find(params[:message_id])
    flash[:notice] = "<a href=\"/user/show/#{@message.sender}\">#{@message.sender_p.display_name}</a> has been added to your <a href=\"/user/list/#{@message.person_id}\">friends</a>" if @message.accept_friendship(params[:acceptance])
    redirect_to :action => 'list', :controller => 'message'
  end
  
  def reset_password
    @needs_confirmation = false
    if params[:id].nil?
      @person = Person.find(session[:user_id])
      @needs_confirmation = true
    else
      @person = Person.find(params[:id])
      @temp_pass = params[:temp_pass]
    end
  end
  
  def update_password
    @person = Person.find(params[:person][:id])
    if params[:person][:password] == params[:person][:password_confirmation]
      if @person.change_password(params[:temp_password], params[:person][:password])
        flash[:notice] = "Your password has been successfully changed"
        session[:user_id] = @person.id
        redirect_to :action => 'home'
        return
      else
        flash[:notice] = "The password you typed for your old password was not correct. If you need to reset your password, click <a href=\"#{url_for(:controller => 'user', :action => 'retrieve')}\">here</a>."
        @needs_confirmation = true
        render :action => 'reset_password'
        return
      end
    else
      flash[:notice] = "The passwords you typed do not match"
      redirect_to :action => 'reset_password', :temp_pass => params[:temp_password]
    end
  end
  
  def item_locations
    @person = Person.find(session[:user_id])
    @locations = @person.all_locations
    @items = @person.items
    @loc_items = Hash.new
    @items.each do |item|
      loc = item.locations.current
      @loc_items[loc.id] = ([@loc_items[loc.id], nil] << item).flatten.compact || [item] unless loc.nil?
    end
#    timing @loc_items.pretty_inspect
    @unfound_items = @items.clone.delete_if { |i| @locations.include?(i.locations.current)}
#    timing @items.pretty_inspect
#    timing @unfound_items.pretty_inspect
  end
  
end
