# == Schema Information
# Schema version: 10
#
# Table name: items
#
#  id          :integer       default(0), not null, primary key
#  name        :string(255)   default()
#  description :text          default()
#  person_id   :integer       default(0)
#  created_on  :date          
#

class Item < ActiveRecord::Base
  has_many :locations

end
