# == Schema Information
# Schema version: 12
#
# Table name: items
#
#  id          :integer       default(0), not null, primary key
#  tbid        :string(255)   default()
#  name        :string(255)   default()
#  description :text          default()
#  person_id   :integer       default(0)
#  created_on  :date          
#

require 'digest/sha1'

class Item < ActiveRecord::Base
  has_one :location
  belongs_to :person
  validates_uniqueness_of :tbid
  
  def generate_tbid
    digest = Digest::SHA1.new
    digest << Time.now
    digest << self.id
    digest << self.description
    tbid = digest.hexdigest
    timing "tbid: #{tbid}"
    self.tbid = tbid.slice(2..10)
    unless self.save # if the id is not unique
      self.generate_tbid
    end
  end

  def change_owners(new_owner, date = Time.now)
    change = Change.new
    change.change_type = Change.OWNERSHIP
    change.old_value = self.person
    change.new_value = new_owner
    change.effective_date = date
    change.item_id = self.id
    change.save!
    self.person_id = new_owner
    self.save!
  end
end
