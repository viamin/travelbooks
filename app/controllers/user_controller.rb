class UserController < ApplicationController
  before_filter :authorize, :except => [:login, :join, :retrieve, :mark_friends, :mark_items]
  
  def index
    redirect_to :action => 'home'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @person = Person.find(params[:id])
    @friends = @person.friends
    @map = Mapstraction.new("friend_map",:yahoo)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([36.9732, -122.0135],10)
  	#@map.marker_init(Marker.new([75.6,-42.467],:label => "Hello", :info_bubble => "Info! Info!", :icon => "/images/icon02.png"))
    render :layout => false
  end

  def show
    @person = Person.find(params[:id])
    if @person == Person.find(session[:user_id])
      redirect_to :action => 'edit'
    end
    @location = @person.current_location
    @items = @person.items
    @friends = @person.friends
    @map = Mapstraction.new('user_map', :yahoo)
    @map.control_init(:small => true)
    @map.center_zoom_init([@location.lat, @location.lng], 10)
    @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @location.description))
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
      @items = @person.all_items.uniq
      @friends = @person.friends
      @map = Mapstraction.new('user_map', :yahoo)
      @map.control_init(:small => true)
      @map.center_zoom_init([@location.lat, @location.lng], 10)
      @map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @location.description))
    end
  end  
  
  def login
    login_status = nil
    unless request.get?
      logged_in_user = Person.login(params[:person][:login], params[:person][:password])
      logged_in_email = Person.email_login(params[:person][:login], params[:person][:password])
      if logged_in_user.kind_of?(Person)
        session[:user_id] = logged_in_user.id
        login_status = :success
        next_action = :redirect
      elsif logged_in_email.kind_of?(Person)
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
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :controller => 'main', :action => 'index'
  end
  
  def retrieve
    retrieve = params[:retrieve]
    if retrieve['loop'] == 'True'
      if validate_email(retrieve['email_address'])
        
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
    @friends = @person.friends.collect {|f| f.current_location }
    @friend_markers = @friends.collect {|f| Marker.new([f.lat, f.lng]) }
    @center = find_center(@friends)
    width, height = params[:width], params[:height]
    @zoom = best_zoom(@friends, @center, width, height)
    @map = Variable.new("map")
  end
  
  def mark_items
    @person = Person.find(params[:id])
    @items = @person.all_items.collect {|i| i.current_location }
    timing "Items: #{@items.pretty_inspect}"
    @item_markers = @items.collect {|i| Marker.new([i.lat, i.lng]) }
    @center = find_center(@items)
    width, height = params[:width], params[:height]
    @zoom = best_zoom(@items, @center, width, height)
    @map = Variable.new("map")
  end
  
end
