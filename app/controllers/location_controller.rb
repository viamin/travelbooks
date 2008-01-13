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
    @person = Person.find(params[:person_id])
  end
  
  def create
    @person = Person.find(session[:user_id])
    @location = Location.create(params[:location])
    if params[:location][:current] == 'on' 
      old_loc = @person.current_location
      
    end
    #update person's location list
    redirect_to :action => 'list'
  end
  
  def update
    @location = Location.find(params[:location][:id])
    @person = Person.find(session[:user_id])
    if @location.used_elsewhere?
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
    @person = Person.find(params[:person_id])
    @person.remove_location(@location)
    @location.destroy unless @location.used_elsewhere?
    redirect_to :action => 'list'
  end
end
