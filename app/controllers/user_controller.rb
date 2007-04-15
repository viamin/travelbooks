class UserController < ApplicationController
  def index
    redirect_to :action => 'home'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #Change this to only show friends of the logged in person
    @person_pages, @people = paginate :people, :per_page => 10
  end

  def show
    @person = Person.find(params[:id])
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
      flash[:notice] = 'Person was successfully updated.'
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
    
    @person = Person.find(session[:user_id]) unless session[:user_id].nil?
    if @person.nil?
      redirect_to :action => 'login'
    else
      @visitor = @person.first_name
      @location = @person.current_location
      @items = @person.items
    end
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([38.134557,-95.537109],4)
    
  end  
  
  def login
    unless request.get?
      logged_in_user = Person.login(params[:person][:login], params[:person][:password])
      logged_in_email = Person.email_login(params[:person][:login], params[:person][:password])
      if logged_in_user.kind_of?(Person)
        session[:user_id] = logged_in_user.id
        redirect_to(:action => "home")
      elsif logged_in_email.kind_of?(Person)
        session[:user_id] = logged_in_email.id
        redirect_to(:action => "home")
      else
        flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
        redirect_to(:action => :login)
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
          @person.changes.create( :location => @location, :effective_date => Time.now, :change_type => 2, :new_value => @location.id.to_s)
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
  
end
