class UserController < ApplicationController
  def index
    redirect_to :action => 'home'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
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

  def edit
    @person = Person.find(params[:id])
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
    @person = Person.find(session[:user_id])
    if @person.nil?
      @visitor = "<a href=\"login\">Guest</a>"
      @location = Location.new
# Think about using www.hostip.info database
      @location.zip_code = "92024"
    else
      @visitor = @person.first_name
      @location = @person.location
      @items = @person.items
    end
  end  
  
  def login
    unless request.get?
=begin
        @person = Person.new(params[:person])
        logged_in_user = @person.try_to_login
        logged_in_email = @person.try_email_login
=end
      logged_in_user = Person.login(params[:person][:username], params[:person][:password])
      logged_in_email = Person.email_login(params[:person][:username], params[:person][:password])
      if logged_in_user.kind_of?(Person)
        session[:user_id] = logged_in_user.id
        redirect_to(:action => "home")
      elsif logged_in_email.kind_of?(Person)
        session[:user_id] = logged_in_email.id
        redirect_to(:action => "home")
      else
        flash[:notice] = "Invalid user/password combination"
        redirect_to(:action => :login)
      end
    end
  end

  def join
    if request.get?
      @person = Person.new
      @person.birthday = "0000-00-00"
      @location = Location.new
    else
      @person = Person.new(params[:person])
      @location = Location.new(params[:location])
   # Change this to put the @person and @location saves in a transaction to make sure both of them go through or none. 
      if @person.save
        @location.person_id = @person.id
        if @location.save
          flash[:notice] = "Thank you for joining TravellerBook.com"
          session[:user_id] = @person.id
          redirect_to(:action => :home)
        else
          flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
          redirect_to(:action => :login)
        end
      end
    end
  end
end
