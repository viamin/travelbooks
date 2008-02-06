class AdminController < ApplicationController
  before_filter :admin_auth
  layout 'user'
  
  def books
    @books = Item.find(:all)
  end
  
  def add_book
    @book = Item.new
    @book.generate_tbid
  end
  
  def create_book
    @book = Item.create(params[:item])
    redirect_to :action => 'books'
  end
  
  def show_book
    
  end
  
  def edit_book
    
  end
  
  def destroy_book
    Item.find(params[:id]).destroy
    redirect_to :action => 'books'
  end
  
  def people
    
  end
  
  def locations
    
  end
  
end
