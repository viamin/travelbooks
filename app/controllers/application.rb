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
      min_lat = loc.lat if loc.lat < min_lat
      max_lat = loc.lat if loc.lat > max_lat
      min_lng = loc.lng if loc.lng < min_lng
      max_lng = loc.lng if loc.lng > max_lng
    end
    # need to compare zoom levels to pixel sizes for lat/lng intervals
  end
end