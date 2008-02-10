# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  private
  
  # Makes sure the user is logged in and has a session before displaying certain pages
  def authorize
    if (session[:user_id].nil? || session[:user_id] == "")
      redirect_to :controller => 'user', :action => 'login'
      return
    end
  end
  
  def admin_auth
    unless (session[:user_id] == 1 && Person.find(session[:user_id]).email == "bart@sonic.net")
      flash[:notice] = "You don't have access to that page."
      redirect_to :controller => 'user', :action => 'login'
      return
    end
  end
  
  # find_center takes an array of objects with a current_location method and
  # calculates the center point of the collection
  def find_center(collection)
    sum_lat = 0.0
    sum_lng = 0.0
    count = 0
    collection.each do |llp| # should be a collection of LatLonPoints
      count += 1
      sum_lat += llp.lat unless llp.lat.nil?
      sum_lng += llp.lon unless llp.lon.nil?
    end
    {:lng => sum_lng / count, :lat => sum_lat / count} #return a hash
    [sum_lat/count, sum_lng/count] # return an array
  end
  
  # find_center takes an array of objects with a current_location method and
  # calculates the best zoom level to show all of the points given a center point. 
  def best_zoom(collection, center_point, width, height)
    min_lat, max_lat, min_lng, max_lng = 0, 0, 0, 0
    collection.each do |loc|
      if loc.class == Location
        min_lat = loc.lat if loc.lat < min_lat
        max_lat = loc.lat if loc.lat > max_lat
        min_lng = loc.lng if loc.lng < min_lng
        max_lng = loc.lng if loc.lng > max_lng
      elsif loc.class == Array # expecting [lat, lng] array elements
        min_lat = loc.first if loc.first < min_lat
        max_lat = loc.first if loc.first > max_lat
        min_lng = loc.last if loc.last < min_lng
        max_lng = loc.last if loc.last > max_lng
      end
    end
    distance_diag = calculate_distance2(min_lat, min_lng, max_lat, max_lng)
    pixels_diag = Math.sqrt(width ** 2 + height ** 2)
    meters_per_pixel_needed = distance_diag / pixels_diag
    # compare here, meters per pixel to this number for different zoom levels
    zoom_levels_yahoo = [0, 2**0, 2**1, 2**2, 2**3, 2**4, 2**5, 2**6, 2**7, 2**8, 2**9, 2**10, 2**11, 2**12, 2**13, 2**14, 2**15, 2**16, 2**17] #start close in and zoom out
    zoom_levels_yahoo.each_with_index do |zl, i|
      zoom = (18 - i) if meters_per_pixel_needed > zl
    end
    zoom = 10 if (zoom.nil? || zoom == 0)
    zoom
  end
  
  # returns an array of points for the given vacation
  def get_points_for(vacation)
    points = Array.new
    vacation.destinations.each do |d|
      if d.has_location?
        points << LatLonPoint.new([d.location.lat, d.location.lng])
      end
    end
    points
  end
  
  def get_markers_for(vacation)
    markers = Array.new
    vacation.destinations.each do |d|
      if d.has_location?
        markers << Marker.new([d.location.lat, d.location.lng], :info_bubble => d.name, :icon => '/images/desticon.png')
      end
    end
    markers
  end
  
  ######################### Experimental ##########################
  def calculate_distance(lat1, lon1, lat2, lon2)
    radius_earth = 6371000
    # 1 Degree is 69.096 miles, 1 mile is 1609.34 m
    a = Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.cos(lon1 * Math::PI / 180) * Math.cos(lon2 * Math::PI / 180)
    b = Math.cos(lat1 * Math::PI / 180) * Math.sin(lon1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(lon2 * Math::PI / 180)
    c = Math.sin(lat1 * Math::PI / 180) * Math.sin(lat2 * Math::PI / 180)
    if (a + b + c) >= 1 || (a + b + c) <= -1 
      distance = 0
    else
      distance = Math.acos(a + b + c) * radius_earth #Distance will be in meters
    end
  end

  def calculate_distance2(lat1, lon1, lat2, lon2)
    meters_per_lat_degrees = 111113.519
    delta_lat = (lat2 - lat1).abs
    delta_lon = (lon2 - lon1).abs
    center_lon = (lon1 + lon2) / 2
    metres_per_degree_lng = metres_per_degree_lng(center_lon)
    delta_lat_meters = delta_lat * metres_per_degree_lng
    delta_lon_meters = delta_lon * meters_per_lat_degrees
    distance = Math.sqrt(delta_lat_meters ** 2 + delta_lon_meters ** 2)
  end

  def metres_per_degree_lng(lat)
    earth_radius_meters = 6378007
    earth_circum_meters = earth_radius_meters * 2 * Math::PI
    (Math.cos(lat * (Math::PI / 180)) * earth_circum_meters) / 360
  end
  
end