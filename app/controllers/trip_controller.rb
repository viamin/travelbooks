class TripController < ApplicationController
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
    @trip = Trip.find(params[:id])
  end
  
  def create
    @person = Person.find(session[:user_id])
    @trip = Trip.create(params[:trip])
    @person.trips << @trip
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
    @trips = @person.trips
    @map = Mapstraction.new("vacation_map", MAP_TYPE)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@location.lat, @location.lng],9)
  	@map.marker_init(Marker.new([@location.lat, @location.lng], :info_bubble => @location.description, :icon => '/images/homeicon.png'))
#  	@trips.each do |v|
#  	  points = get_markers_for(v)
#  	  line = Polyline.new(points, :width => 5, :color => COLORS[rand(6)], :opacity => 0.8)
#  	  @map.polyline_init(line)
#	  end
  end
  
  def add
    @trip = Trip.find(params[:id])
    @destination = Destination.new
  end
  
  def insert
    @trip = Trip.find(params[:trip_id])
    @destination = Destination.create(params[:destination])
    @trip.destinations << @destination
    @trip.save!
    redirect_to :action => 'edit', :id => @trip.id
  end
  
  def add_book
    @trip = Trip.find(params[:id])
    @person = Person.find(session[:user_id])
    @items = @person.items
  end
  
  def insert_book
    @trip = Trip.find(params[:id])
    @item = Item.find(params[:item_id])
    @trip.items << @item
    redirect_to :action => 'edit', :id => @trip
  end
  
  def sort
    @trip = Trip.find(params[:id])
    @trip.destinations.each do |dest|
      dest.position = params['trip'].index(dest.id.to_s) + 1
      dest.save
    end
    render :nothing => true
  end
  
  def add_loc
    @destination = Destination.find(params[:id])
    @location = Location.new
    @location.description = @destination.name
    @all_locations = Person.find(Trip.find(@destination.trip_id).person_id).all_locations
    render :layout => false
  end
  
  def assoc_loc
    @destination = Destination.find(params[:destination][:id])
    @location = Location.create(params[:location])
    @destination.location = @location
    @destination.save!
    redirect_to :action => 'edit', :id => @destination.trip_id
  end
  
  def zoom
    @trip = Trip.find(params[:id])
    @map = Variable.new("map")
#    @map = Mapstraction.new("vacation_map", MAP_TYPE)
#  	@map.control_init(:small => true)
	  @points = get_points_for(@trip)
	  @markers = get_markers_for(@trip)
	  timing @markers.pretty_inspect
	  @center = LatLonPoint.new(find_center(@points))
	  @zoom = best_zoom(@points, @center, 227, 458) #227x458 is size of map on page
	  timing @center.pretty_inspect
	  timing @zoom.pretty_inspect
#	  @map.center_zoom_init(@center, @zoom)
	  @line = Polyline.new(@points, :width => 5, :color => COLORS[rand(6)], :opacity => 0.8)
#	  @map.polyline_init(@line)
	  render :layout => false
  end
  
end
