class TripController < ApplicationController
  before_filter :authorize
  cache_sweeper :trip_sweeper, :only => [:create, :update]
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  def index
    list
    render :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :insert],
         :redirect_to => { :action => :list }
  
  def new
    @person = Person.find(session[:user_id])
    
  end
  
  def edit
    @person = Person.find(session[:user_id])
    @trip = Trip.find(params[:id])
    @item_count = @person.items.length
  end
  
  def create
    @person = Person.find(session[:user_id])
    @trip = Trip.new(params[:trip])
    @trip.save!
    @person.trips << @trip
    redirect_to :action => 'list'
  end
  
  def destroy
    @person = Person.find(session[:user_id])
    
  end
  
  def update
    @person = Person.find(session[:user_id])
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      flash[:notice] = 'Trip was successfully updated.'
      redirect_to :action => 'edit', :id => @trip
      return
    else
      render :action => 'edit', :id => @trip
      return
    end
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
    @person = Person.find(session[:user_id])
    @trip = Trip.find(params[:id])
    @destination = Destination.new
  end
  
  def insert
    @trip = Trip.find(params[:id])
    @person = Person.find(session[:user_id])
    @destination = Destination.create(params[:destination])
    @trip.destinations << @destination
    if @trip.save
      redirect_to :action => 'edit', :id => @trip
    else
      render :action => 'add', :id => @trip
    end
  end
  
  def add_book
    @trip = Trip.find(params[:id])
    @person = Person.find(session[:user_id])
    @items = @person.items
  end
  
  def insert_book
    @trip = Trip.find(params[:id])
    @item = Item.find(params[:book])
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
    @all_locations = @destination.trip.person.all_locations.concat(@destination.other_locations)
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
#	  timing @markers.pretty_inspect
	  @center = LatLonPoint.new(find_center(@points))
	  @zoom = best_zoom(@points, @center, 227, 458) #227x458 is size of map on page
#	  timing @center.pretty_inspect
#	  timing @zoom.pretty_inspect
#	  @map.center_zoom_init(@center, @zoom)
	  @line = Polyline.new(@points, :width => 5, :color => COLORS[rand(6)], :opacity => 0.8)
#	  @map.polyline_init(@line)
	  render :layout => false
  end
  
  def edit_dest
    @person = Person.find(session[:user_id])
    @destination = Destination.find(params[:id])
  end
  
  def update_dest
    @destination = Destination.find(params[:id])
    if @destination.update_attributes(params[:destination])
      redirect_to :action => 'edit', :id => @destination.trip
    else
      render :action => 'edit_dest'
    end
  end
  
  def delete_dest
    @destination = Destination.find(params[:id])
    @trip = @destination.trip
    @destination.destroy
    redirect_to :action => 'edit', :id => @trip
  end
  
  def update_dest_loc
    @destination = Destination.find(params[:destination_id])
    @location = @destination.location
    if @location.update_attributes(params[:location])
      redirect_to :action => 'edit', :id => @destination.trip
    else
      render :action => 'edit_dest'
    end
  end
  
end
