class UserController < ApplicationController
  before_filter :authorize, :except => [:login, :join, :retrieve, :mark_friends, :mark_items, :iforgot]
  layout 'user', :except => 'user_stats'
  
  MAP_TYPE = :yahoo
  
  def index
    redirect_to :action => 'home'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @person = Person.find(params[:id])
    @location = @person.current_location
    @friends = @person.friends
    @map = Mapstraction.new("friend_map", MAP_TYPE)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@location.lat, @location.lng],10)
  	@map.marker_init(Marker.new([@location.lat, @location.lng], :icon => '/images/homeicon.png'))
  	@friends.each do |f|
  	  fl = f.current_location
  	  @map.marker_init(Marker.new([fl.lat, fl.lng], :info_bubble => f.display_name, :icon => '/images/personicon.png'))
	  end
  end

  def show
    if (params[:id] == session[:user_id])
      redirect_to :action => 'home'
      return
    end
    @person = Person.find(params[:id])
    @me = Person.find(session[:user_id])
    @location = @person.current_location
    @items = @person.items
    @friends = @person.friends
    @is_my_friend = @friends.include?(@me)
    unless @is_my_friend
      @is_my_friend = Message.check_for_request(@me, @person)
    end
    @map = Mapstraction.new('user_map', MAP_TYPE)
    @map.control_init(:small => true)
    @map.center_zoom_init([@location.lat, @location.lng], 10)
    @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @person.display_name, :icon => '/images/personicon.png'))
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to :action => 'list'
      return
    else
      render :action => 'new'
      return
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
          return
        end
      end
    end
    @person = Person.find(session[:user_id]) unless session[:user_id].nil?
    if @person.nil?
      redirect_to :action => 'login'
    else
      @location = @person.current_location
      @locations = @person.all_locations
      @items = @person.items
      @friends = @person.friends
      @map = Mapstraction.new('user_map', MAP_TYPE)
      @map.control_init(:small => true)
      @map.center_zoom_init([@location.lat, @location.lng], 10)
      @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @location.description, :icon => '/images/homeicon.png'))
      @locations.each do |l|
        unless l == @location
          @map.marker_init(Marker.new([l.lat, l.lng], :info_bubble => l.description))
        end
      end
    end
  end  
  
  def login
    unless session[:user_id].nil?
      redirect_to :action => 'home'
      return
    end
    login_status = nil
    if params[:person] && Person.is_valid_login?(params[:person][:email])
      unless request.get?
        person = Person.email_login(params[:person][:email], params[:person][:password])
        if person.kind_of?(Person)
          session[:user_id] = person.id
          login_status = :success
          next_action = :redirect
        else
          flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
          login_status = :failed
          next_action = :redirect
        end
        if next_action == :redirect
          if login_status == :success
            if person.needs_reset == true
              flash[:notice] = "Your password was recently reset. You will need to enter a new password in order to log in next time."
              redirect_to :action => 'reset_password', :temp_pass => params[:person][:password]
              return
            else
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
    session[:user_id] = nil
    redirect_to :controller => 'main', :action => 'index'
  end
  
  def retrieve
    
  end
  
  def iforgot
    if (params.nil? || params.empty? || params[:retrieve].nil? || params[:retrieve].empty?)
      redirect_to :action => 'retrieve'
      return
    else
      @person = Person.find(:first, :conditions => {:email => params[:retrieve][:email_address]})
      if @person.nil?
        flash[:notice] = "There was no user found with that email address."
        render :action => 'retrieve'
      else
        @person.send_reset_email
      end
    end
  end

  def join
    if request.get?
      @person = Person.new
      @location = Location.new
    else
      @person = Person.new(params[:person])
      @location = Location.new(params[:location])
      if @location.has_good_info?
        @location.loc_type = 1
        @location.person = @person
   # Change this to put the @person and @location saves in a transaction to make sure both of them go through or none. 
      if @person.save
        if @location.has_good_info? && @location.save!
          @person.changes.create( :location => @location, :person => @person, :effective_date => Time.now, :change_type => Change::PERSON_LOCATION, :new_value => @location.id.to_s)
        end
          flash[:notice] = "Thank you for joining TravellerBook.com"
          session[:user_id] = @person.id
          redirect_to :action => :home
        else
          flash[:notice] = "Sorry, there was a problem creating your account."
          render :action => :join
        end
      else
        flash[:notice] = "There was a problem creating your account"
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
    @map = Variable.new("map")
  end
  
  def mark_items
    @person = Person.find(params[:id])
    @items_loc = @person.all_items.collect {|i| i.locations.current }
    @center = find_center(@items_loc)
    width, height = params[:width], params[:height]
    @zoom = best_zoom(@items_loc, @center, width, height)
    @map = Variable.new("map")
  end
  
  def show_trips
    @person = Person.find(params[:id])
    if @person.share_trips
      @trips = @person.trips
    else
      @trips = [Trip.new]
    end
    @map = Variable.new("map")
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
    @person = Person.find(params[:id])
    @friend = Person.find(params[:friend_id])
    if params[:commit] == "Confirm"
      flash[:notice] = "A message has been sent to #{@friend.display_name}."
      Message.send_request(@person, @friend)
    end
    redirect_to :action => 'show', :id => @friend.id
  end
  
  def accept
    @message = Message.find(params[:message_id])
    @message.accept_friendship(params[:commit])
    redirect_to :action => 'list', :controller => 'message'
  end
  
  def flash_test
    flash[:notice] = "Test of the flash. This is a test of a long flash message to see how it looks in the floating flash box."
    redirect_to :action => 'home'
  end
  
  def reset_password
    @person = Person.find(session[:user_id])
    @temp_pass = params[:temp_pass]
  end
  
  def update_password
    @person = Person.find(params[:person][:id])
    if params[:person][:password] == params[:person][:password_confirmation]
      if @person.change_password(params[:temp_password], params[:person][:password])
        flash[:notice] = "Your password has been successfully changed"
        redirect_to :action => 'home'
        return
      else
        render :action => 'reset_password'
        return
      end
    else
      flash[:notice] = "The passwords you typed do not match"
      redirect_to :action => 'reset_password', :temp_pass => params[:temp_password]
    end
  end
  
  def user_stats
    @person = Person.find(params[:id])
    @trips = @person.trips
    @items_given = @person.items_given.length
    @items_received = @person.items_received.length
    @countries_visited = 0
    @countries_books_visited = 0
    @miles_travelled = 0
    @miles_books_given_travelled = 0
    @miles_last_book = 0
  end
  
end
