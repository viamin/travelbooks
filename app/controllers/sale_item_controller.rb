class SaleItemController < ApplicationController
  before_filter :admin_auth
  layout 'user'
  
  def index
    redirect_to :controller => 'shop'
  end
  
  def list
    @sale_items = SaleItem.find(:all)
  end
  
  def show
    @sale_item = SaleItem.find(params[:id])
  end
  
  def edit
    @sale_item = SaleItem.find(params[:id])
  end
  
  def update
    @sale_item = SaleItem.find(params[:sale_item][:id])
    if @sale_item.update_attributes(params[:sale_item])
      redirect_to :action => 'list'
    else
      render :action => 'edit', :id => params[:sale_item][:id]
    end
  end
  
  def new
    @sale_item = SaleItem.new
  end
  
  def create
    @sale_item = SaleItem.create(params[:sale_item])
    redirect_to :action => 'list'
  end
  
  def delete
    SaleItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
