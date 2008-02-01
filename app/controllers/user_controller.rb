class UserController < ApplicationController
  before_filter :authorize, :except => [:login, :join, :retrieve, :mark_friends, :mark_items, :iforgot]
  
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
    @map = Mapstraction.new("friend_map",:yahoo)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@location.lat, @location.lng],10)
  	@map.marker_init(Marker.new([@location.lat, @location.lng], :icon => '/images/homeicon.png'))
  	@friends.each do |f|
  	  fl = f.current_location
  	  @map.marker_init(Marker.new([fl.lat, fl.lng], :info_bubble => f.display_name, :icon => '/images/personicon.png'))
	  end
    render :layout => false
  end

  def show
    @person = Person.find(params[:id])
    @me = Person.find(session[:user_id])
    if (@person == @me)
      redirect_to :action => 'home'
    end
    @location = @person.current_location
    @items = @person.items
    @friends = @person.friends
    @is_my_friend = @friends.include?(@me)
    unless @is_my_friend
      @is_my_friend = Message.check_for_request(@me, @person)
    end
    @map = Mapstraction.new('user_map', :yahoo)
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
    unless session[:current_action] == :user_home
      case session[:current_action]
      when :user_add_item
        unless session[:item_last_viewed].nil?
          redirect_to :controller => 'item', :action => 'associate', :id => session[:item_last_viewed]
          return
        else
          session[:current_action] = :user_home
        end
      end
    end
    @person = Person.find(session[:user_id]) unless session[:user_id].nil?
    if @person.nil?
      redirect_to :action => 'login'
    else
      @location = @person.current_location
      @locations = @person.all_locations
      @items = @person.all_items
      @friends = @person.friends
      @map = Mapstraction.new('user_map', :yahoo)
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
    login_status = nil
    if Person.is_valid_login?(params[:person][:login])
      unless request.get?
        logged_in_email = Person.email_login(params[:person][:login], params[:person][:password])
        if logged_in_email.kind_of?(Person)
          session[:user_id] = logged_in_email.id
          login_status = :success
          next_action = :redirect
        else
          flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
          login_status = :failed
          next_action = :redirect
        end
        if next_action == :redirect
          if session[:current_action] == :user_add_item
            redirect_to :action => 'associate', :controller => 'item', :id => session[:item_last_viewed]
          elsif login_status == :success
            redirect_to :action => "home"
          else
            redirect_to :action => 'login'
          end
        end
      end
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
    @person = Person.find(:first, :conditions => {:email => params[:retrieve][:email_address]})
    @person.send_reset_email
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
      if @person.save!
        if @location.has_good_info? && @location.save!
          @person.changes.create( :location => @location, :person => @person, :effective_date => Time.now, :change_type => Change::PERSON_LOCATION, :new_value => @location.id.to_s)
        end
          flash[:notice] = "Thank you for joining TravellerBook.com"
          session[:user_id] = @person.id
          redirect_to(:action => :home)
        else
          flash[:notice] = "Sorry, there was a problem creating your account."
          redirect_to(:action => :join)
        end
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
      flash[:notice] = "A message will been sent to #{@friend.display_name}."
      Message.send_request(@person, @friend)
    end
    redirect_to :action => 'show', :id => @friend.id
  end
  
  def accept
    @message = Message.find(params[:message_id])
    @message.accept_friendship(params[:commit])
    redirect_to :action => 'list', :controller => 'message'
  end
  
end
