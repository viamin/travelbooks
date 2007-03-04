# == Schema Information
# Schema version: 11
#
# Table name: line_items
#
#  id               :integer       not null, primary key
#  shopping_cart_id :integer       default(0)
#  order_id         :integer       default(0)
#  sale_item_id     :integer       default(0)
#  quantity         :integer       default(0)
#  price_per_item   :float         default(0.0)
#  created_on       :date          
#

class LineItem < ActiveRecord::Base
  belongs_to :sale_item
  belongs_to :shopping_cart
end
