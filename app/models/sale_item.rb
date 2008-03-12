# == Schema Information
# Schema version: 30
#
# Table name: sale_items
#
#  id                :integer         not null, primary key
#  name              :string(255)     not null
#  description       :string(255)     not null
#  quantity_in_stock :integer         default(0)
#  price             :float           default(0.0)
#  for_sale          :string(255)     not null
#  sale_price        :float           default(0.0)
#  status            :integer         
#  category_id       :integer         
#  created_on        :date            
#  updated_on        :date            
#  sale_ends         :date            
#  sale_begins       :date            
#

class SaleItem < ActiveRecord::Base
  has_many :shopping_carts
  belongs_to :category
  validates_numericality_of :price, :quantity_in_stock, :sale_price
  
  STATUS = [["Normal Price", 1], ["On Sale", 2], ["Going on sale", 3], ["Not on Sale", 4]]

end
