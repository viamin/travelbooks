# == Schema Information
# Schema version: 22
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
  
  def create_symmetrical
    unless self.symmetry_exists?
      @sym_friend = Friend.new
      @sym_friend.owner_person_id = self.entry_person_id
      @sym_friend.entry_person_id = self.owner_person_id
      @sym_friend.permissions = self.permissions
      @sym_friend.save
    end
  end
  
  def symmetry_exists?
    @sym = Friend.find(:all, :conditions => {:owner_person_id => self.entry_person_id, :entry_person_id => self.owner_person_id})
    !@sym.empty?
  end
  
end
