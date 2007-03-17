# == Schema Information
# Schema version: 14
#
# Table name: sale_items
#
#  id                :integer       not null, primary key
#  name              :string(255)   not null
#  description       :string(255)   not null
#  quantity_in_stock :integer       default(0)
#  price             :float         default(0.0)
#  for_sale          :string(255)   not null
#  sale_price        :float         default(0.0)
#  status            :integer       default(0)
#  category_id       :integer       default(0)
#

class SaleItem < ActiveRecord::Base
  has_many :shopping_carts
  belongs_to :category
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.name = String.new
      self.description = String.new
      self.for_sale = String.new
    end
  end

end
