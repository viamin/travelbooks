# == Schema Information
# Schema version: 37
#
# Table name: statuses
#
#  id          :integer         not null, primary key
#  person_id   :integer
#  item_id     :integer
#  status      :string(255)
#  status_type :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Status < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  has_one :location
  
  ################# TYPES ##################
  PERSON_STATUS = 2**0
  ITEM_STATUS = 2**1
end
