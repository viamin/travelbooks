class ShopController < ApplicationController
  layout 'user'

  def index
    render :action => 'coming_soon'
#    render :action => 'store'
  end

  def store
#    @items = SaleItem.find(:all, :conditions => ["status != 4 and quantity_in_stock > 0"])
    redirect_to :action => 'coming_soon'
  end
  
  def coming_soon
    
  end
  
  def show
#    @item = SaleItem.find(params[:id])
    redirect_to :action => 'coming_soon'
  end
  
  def purchase
#    @item = SaleItem.find(params[:id])
    redirect_to :action => 'coming_soon'
  end

end
