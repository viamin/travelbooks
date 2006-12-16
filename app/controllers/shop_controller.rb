class ShopController < ApplicationController

  def index
    redirect_to(:action => 'store')
  end

  def store
    @items = SaleItem.find(:all, :conditions => ["for_sale = 'yes' and quantity_in_stock > 0"])
  end

end
