class ShopController < ApplicationController
  layout 'user'

  def index
    redirect_to(:action => 'store')
  end

  def store
#    @items = SaleItem.find(:all, :conditions => ["for_sale = 'yes' and quantity_in_stock > 0"])
    redirect_to :action => 'coming_soon'
  end
  
  def coming_soon
    
  end

end
