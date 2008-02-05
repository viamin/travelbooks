class VacationController < ApplicationController
  before_filter :authorize
  layout 'user'
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :insert],
         :redirect_to => { :action => :list }
  
  def new
    @person = Person.find(session[:user_id])
    
  end
  
  def edit
    @person = Person.find(session[:user_id])
    @vacation = Vacation.find(params[:id])
  end
  
  def create
    @person = Person.find(session[:user_id])
    @vacation = Vacation.create(params[:vacation])
    @person.vacations << @vacation
    @person.save!
    redirect_to :action => 'list'
  end
  
  def destroy
    @person = Person.find(session[:user_id])
    
  end
  
  def update
    @person = Person.find(session[:user_id])
    
  end
  
  def list
    @person = Person.find(session[:user_id])
    @location = @person.current_location
    @vacations = @person.vacations
    @map = Mapstraction.new("vacation_map",:yahoo)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@location.lat, @location.lng],10)
  	collection = Array.new
  	@vacations.each do |v|
  	  points = get_markers_for(v)
  	  line = Polyline.new(points, :width => 5, :color => v.color, :opacity => 0.8)
  	  @map.polyline_init(line)
	  end
  end
  
  def add
    @vacation = Vacation.find(params[:id])
    @destination = Destination.new
  end
  
  def insert
    @vacation = Vacation.find(params[:vacation_id])
    @destination = Destination.create(params[:destination])
    @vacation.destinations << @destination
    @vacation.save!
    redirect_to :action => 'edit', :id => @vacation.id
  end
  
  def sort
    @vacation = Vacation.find(params[:id])
    @vacation.destinations.each do |dest|
      dest.position = params['vacation'].index(dest.id.to_s) + 1
      dest.save
    end
    render :nothing => true
  end
  
  def add_loc
    @destination = Destination.find(params[:id])
    @location = Location.new
    @location.description = @destination.name
    render :layout => false
  end
  
  def assoc_loc
    @destination = Destination.find(params[:destination][:id])
    @location = Location.create(params[:location])
    @destination.locations << @location
    @destination.save!
    redirect_to :action => 'list'
  end
  
end
