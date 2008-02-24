# == Schema Information
# Schema version: 26
#
# Table name: shopping_carts
#
#  id          :integer         not null, primary key
#  person_id   :integer         
#  created_on  :date            
#  modified_on :date            
#  last_viewed :date            
#

class ShoppingCart < ActiveRecord::Base
  has_many :line_items
  belongs_to :person

end
