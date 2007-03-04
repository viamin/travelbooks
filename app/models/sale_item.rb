# == Schema Information
# Schema version: 11
#
# Table name: sale_items
#
#  id                :integer       not null, primary key
#  name              :string(255)   default(NULL)
#  description       :string(255)   default(NULL)
#  quantity_in_stock :integer       default(0)
#  price             :float         default(0.0)
#  for_sale          :string(255)   default(NULL)
#  sale_price        :float         default(0.0)
#  status            :integer       default(0)
#  category_id       :integer       default(0)
#

class SaleItem < ActiveRecord::Base
  has_many :shopping_carts
  belongs_to :category

end
