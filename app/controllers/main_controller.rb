class MainController < ApplicationController
  def index
    redirect_to :action => :home
  end

  def tracking
  end

  def about
  end
 
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

  def login
    unless request.get?
      @person = Person.new(params[:person])
      logged_in_user = @person.try_to_login
      logged_in_email = @person.try_email_login
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
          flash[:notice] = "Welcome to TravellerBooks.com!"
          session[:user_id] = @person.id
          redirect_to(:action => :home)
        else
          flash[:notice] = "Sorry, the username/password you entered does not match with any registered users."
          redirect_to(:action => :login)
        end
      end
    end
  end
 
  def home
    @person = Person.find(:first, :conditions => ["id = ?", session[:user_id]])
    if @person.nil?
      @visitor = "<a href=\"login\">Guest</a>"
      @location = Location.new
# Think about using www.hostip.info database
      @location.zip_code = "92024"
    else
      @visitor = @person.first_name
      @location = Location.find(:first, :conditions => ["person_id = ?", @person.id])
      @items = Item.find(:all, :conditions => ["person_id = ?", @person.id])
      @photo = Photo.find(:first, :conditions => ["person_id = ? and photo_type = 1", @person.id])
    end
  end

  def item
    @item = Item.find(:first, :conditions => ["id = ?", params["item_id"]])
  end

  def country

  end

  def stats

  end
  
end
