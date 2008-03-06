class SaleItemController < ApplicationController
  layout 'user'
  
  def list
    @items = SaleItem.find(:all)
  end
  
  def show
    @item = SaleItem.find(params[:id])
  end
  
  def edit
    @item = SaleItem.find(params[:id])
  end
  
  def update
    @item = SaleItem.find(params[:sale_item][:id])
    if @item.update_attributes(params[:sale_item])
      redirect_to :action => 'list'
    else
      render :action => 'edit', :id => params[:sale_item][:id]
    end
  end
  
  def new
    @item = SaleItem.new
  end
  
  def create
    @item = SaleItem.create(params[:sale_item])
    redirect_to :action => 'list'
  end
  
  def delete
    SaleItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
