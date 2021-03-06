class LocationsController < ApplicationController
  before_filter :authorize
  cache_sweeper :person_sweeper, :only => [:create, :update, :destroy, :make_main]
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  def index
    list
    render :action => 'list'
  end
         
  def list
    @person = Person.find(session[:user_id])
    @locations = @person.all_locations
    @current = @person.current_location
  end
  
  def show
    
  end
  
  def new
    @person = Person.find(session[:user_id])
  end
  
  def edit
    @location = Location.find(params[:id])
    @person = Person.find(session[:user_id])
  end
  
  def create
    @person = Person.find(session[:user_id])
    unless params[:commit] == "Cancel"
      @location = Location.create(params[:location])
      new_loc = Change.new
      if params[:location][:current] == 'on' 
        @location.public = true
        @location.save!
        new_loc.change_type = Change::PERSON_MAIN_LOCATION
      else
        new_loc.change_type = Change::PERSON_LOCATION
      end
      new_loc.person_id = @person.id
      new_loc.old_value = @person.current_location.id
      new_loc.new_value = @location.id
      new_loc.effective_date = Time.now
      new_loc.save!
    end
    redirect_to :action => 'list'
  end
  
  def update
    @location = Location.find(params[:id])
    @person = Person.find(session[:user_id])
    if @location.used_elsewhere?
#      timing "Location used elsewhere"
      @new_location = Location.create(params[:location])
      if @location.is_identical_to?(@new_location, false) # false allows the description to change without creating a new location
        @new_location.destroy
        if @location.update_attributes(params[:location])
          flash[:notice] = 'Location was successfully updated.'
          redirect_to :action => 'list'
          return
        else
          render :action => 'edit'
          return
        end
      else
        @person.swap_locations(@location, @new_location)
        redirect_to :action => 'list'
      end
    else
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        redirect_to :action => 'list'
        return
      else
        render :action => 'edit'
        return
      end
    end
  end
  
  def destroy
    @location = Location.find(params[:id])
    @person = Person.find(session[:user_id])
    @person.remove_location(@location)
    @location.destroy unless @location.used_elsewhere?
    redirect_to :action => 'list'
  end
  
  def home
    redirect_to :controller => 'user', :action => 'home'
  end
  
  def make_main
    @location = Location.find(params[:id])
    @person = Person.find(session[:user_id])
    @person.set_main_location(@location)
    redirect_to :action => 'list'
  end

end
