# == Schema Information
# Schema version: 16
#
# Table name: friends
#
#  id              :integer         not null, primary key
#  owner_person_id :integer         
#  entry_person_id :integer         
#  permissions     :integer         
#

class Friend < ActiveRecord::Base
  
  # Unix style permissions: rw-rw-rw-, for user, group, world
  # User permissions will be used to "Friends" list, meaning if the user flag is set 
  # in the permissions, that user is not just in the address book, but is also on the
  # friends list. Not sure yet how that will work
  
  # (TBD)
  
end
