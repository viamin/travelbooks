class ItemSweeper < ActionController::Caching::Sweeper
  observe Item
  
  # Want to expire caches for person under the following conditions:
  # 1. User updates his trips
  # 2. User adds a friend
  # 3. User adds a book
  # 4. User stats change - this happens when #1 or #3 happens, or when a book the person
  #    owned changes hands or goes on a trip
  
  def after_save(item)
    expire_item_cache(item)
  end
  
  private
  
  def expire_item_cache(record)
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "items#{record.person_id}") unless record.person_id.nil?
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "items#{record.person_id}") unless record.person_id.nil?
  end
  
end