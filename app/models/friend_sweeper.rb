class FriendSweeper < ActionController::Caching::Sweeper
  
  # Want to expire caches for person under the following conditions:
  # 1. User updates his trips
  # 2. User adds a friend
  # 3. User adds a book
  # 4. User stats change - this happens when #1 or #3 happens, or when a book the person
  #    owned changes hands or goes on a trip
  
  def after_save(friend)
    timing "Expiring friend cache"
    expire_friend_cache(friend)
  end
  
  private
  
  def expire_friend_cache(record)
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "friends#{record.owner_person_id}") unless record.owner_person_id.nil?
    expire_fragment(:controller => 'user', :action => 'home', :action_suffix => "friends#{record.entry_person_id}") unless record.entry_person_id.nil?
  end
  
end