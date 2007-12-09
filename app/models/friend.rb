# == Schema Information
# Schema version: 14
#
# Table name: friends
#
#  id              :integer         not null, primary key
#  owner_person_id :integer         
#  entry_person_id :integer         
#  permissions     :integer         
#
# owner_person_id is the person_id of the person who added the friend who has id entry_person_id
# This scheme means you can have a friend in your list and you don't have to be on their list
# It also means for a symmetrical friendship you would need two entries in this table. Maybe later
# a symmetrical flag will need to be added but that probably will hurt performance.

class Friend < ActiveRecord::Base
  
  # Unix style permissions: rw-rw-rw-, for user, group, world
  # User permissions will be used to "Friends" list, meaning if the user flag is set 
  # in the permissions, that user is not just in the address book, but is also on the
  # friends list. Not sure yet how that will work
  
  # (TBD)
  
end
