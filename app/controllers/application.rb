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
  
  # find_center takes an array of objects with a current_location method and
  # calculates the center point of the collection
  def find_center(collection)
    sum_lat = 0.0
    sum_lng = 0.0
    count = 0
    collection.each do |loc|
      count += 1
      sum_lat += loc.lat
      sum_lng += loc.lng
    end
    {:lng => sum_lng / count, :lat => sum_lat / count}
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
    # need to compare zoom levels to pixel sizes for lat/lng intervals
  end
  
  # returns an array of points for the given vacation
  def get_markers_for(vacation)
    points = Array.new
    vacation.destinations.each do |d|
      if d.has_location?
        points << LatLonPoint.new([d.location.lat, d.location.lng])
      end
    end
    points
  end
  
  ######################### Experimental ##########################
  def calculate_distance(lat1, lon1, lat2, lon2)
    PI = 3.14159265358979
    RadiusEarth = 6371000
    # 1 Degree is 69.096 miles, 1 mile is 1609.34 m
    a = Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.cos(lon1 * Math::PI / 180) * Math.cos(lon2 * Math::PI / 180)
    b = Math.cos(lat1 * Math::PI / 180) * Math.sin(lon1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(lon2 * Math::PI / 180)
    c = Math.sin(lat1 * Math::PI / 180) * Math.sin(lat2 * Math::PI / 180)
    if (a + b + c) >= 1 || (a + b + c) <= -1 
      distance = 0
    else
      distance = Math.acos(a + b + c) * RadiusEarth #Distance will be in meters
    end
  end

  def calculate_distance2(lat1, lon1, lat2, lon2)
    METRES_PER_LAT_DEGREES = 111113.519

    deltaX = Abs(dX2 - dX1)
    deltaY = Abs(dY2 - dY1)
    centerY = (dY1 + dY2) / 2
    metersPerDegreeLong = MetresPerDegreeLong(dCenterY)
    deltaXMeters = dDeltaX * dMetersPerDegreeLong
    deltaYMeters = dDeltaY * gMETRES_PER_LAT_DEGREES
    getDistance = Sqr(dDeltaXMeters ^ 2 + dDeltaYMeters ^ 2)
  end

  def metres_per_degree_lng(lat)
    EARTH_RADIUS_METRES = 6378007
    EARTH_CIRCUM_METRES = EARTH_RADIUS_METRES * 2 * Math::PI
    (Math.cos(lat * (Math::PI / 180)) * EARTH_CIRCUM_METRES) / 360
  end
  
end