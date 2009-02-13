class TripSweeper < ActionController::Caching::Sweeper
  observe Trip
  
  # Want to expire caches for person under the following conditions:
  # 1. User updates his trips
  # 2. User adds a friend
  # 3. User adds a book
  # 4. User stats change - this happens when #1 or #3 happens, or when a book the person
  #    owned changes hands or goes on a trip
  
  def after_update(trip)
    timing "Expiring map cache"
    # expire cache here 
    expire_map_cache(trip)
  end
  
  private
  
  def expire_map_cache(record)
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "map#{record.person_id}")
  end
  
  def expire_trip_cache(record)
    #nothing cached yet...
  end
  
end