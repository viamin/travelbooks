# == Schema Information
# Schema version: 12
#
# Table name: shopping_carts
#
#  id          :integer       default(0), not null, primary key
#  person_id   :integer       default(0)
#  created_on  :date          
#  modified_on :date          
#  last_viewed :date          
#

class ShoppingCart < ActiveRecord::Base
  has_many :line_items
  belongs_to :person

end
