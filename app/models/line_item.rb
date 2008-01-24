# == Schema Information
# Schema version: 19
#
# Table name: line_items
#
#  id               :integer         not null, primary key
#  shopping_cart_id :integer         
#  order_id         :integer         
#  sale_item_id     :integer         
#  quantity         :integer         
#  price_per_item   :float           
#  created_on       :date            
#

class LineItem < ActiveRecord::Base
  belongs_to :sale_item
  belongs_to :shopping_cart
end
