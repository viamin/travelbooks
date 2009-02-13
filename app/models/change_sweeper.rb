class ChangeSweeper < ActionController::Caching::Sweeper
  observe Change
  
  # Want to expire caches for person under the following conditions:
  # 1. User updates his trips
  # 2. User adds a friend
  # 3. User adds a book
  # 4. User stats change - this happens when #1 or #3 happens, or when a book the person
  #    owned changes hands or goes on a trip
  
  def after_save(change)
    timing "Expiring change cache"
    case change.change_type
    when Change::OWNERSHIP
      expire_item_cache(change)
    when Change::PERSON_LOCATION
      expire_map_cache(change)
    when Change::PERSON_MAIN_LOCATION
      expire_map_cache(change)
    end
  end
  
  private
  
  def expire_map_cache(record)
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "map#{record.person_id}") unless record.person_id.nil?
  end
  
  def expire_item_cache(record)
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "items#{record.new_value}") unless record.new_value.nil?
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "items#{record.old_value}") unless record.old_value.nil?
  end
  
end