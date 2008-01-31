class LocationController < ApplicationController
  before_filter :authorize
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
         
  def list
    @person = Person.find(session[:user_id])
    @locations = @person.all_locations
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
    redirect_to :action => 'list'
  end
  
  def update
    @location = Location.find(params[:location][:id])
    @person = Person.find(session[:user_id])
    if @location.used_elsewhere?
      timing "Location used elsewhere"
      @new_location = Location.new(params[:location])
      @person.swap_locations(@location, @new_location)
      redirect_to :action => 'list'
    else
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        redirect_to :action => 'list'
      else
        render :action => 'edit'
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
end
