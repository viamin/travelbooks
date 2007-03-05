# == Schema Information
# Schema version: 13
#
# Table name: address_book_items
#
#  id              :integer       not null, primary key
#  owner_person_id :integer       default(0)
#  entry_person_id :integer       default(0)
#  permissions     :integer       default(0)
#

class Friend < ActiveRecord::Base
  
  # Unix style permissions: rw-rw-rw-, for user, group, world
  # User permissions will be used to "Friends" list, meaning if the user flag is set 
  # in the permissions, that user is not just in the address book, but is also on the
  # friends list. Not sure yet how that will work
  
  # (TBD)
  
end
