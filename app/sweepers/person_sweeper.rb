class PersonSweeper < ActionController::Caching::Sweeper
  observe Person
  
  # Want to expire caches for person under the following conditions:
  # 1. User updates his trips
  # 2. User adds a friend
  # 3. User adds a book
  # 4. User stats change - this happens when #1 or #3 happens, or when a book the person
  #    owned changes hands or goes on a trip
  
end