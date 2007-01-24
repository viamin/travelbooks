# == Schema Information
# Schema version: 12
#
# Table name: sale_items
#
#  id                :integer       default(0), not null, primary key
#  name              :string(255)   default()
#  description       :string(255)   default()
#  quantity_in_stock :integer       default(0)
#  price             :float         default(0.0)
#  for_sale          :string(255)   default()
#  sale_price        :float         default(0.0)
#  status            :integer       default(0)
#  category_id       :integer       default(0)
#

class SaleItem < ActiveRecord::Base
  has_many :shopping_carts
  belongs_to :category

end
