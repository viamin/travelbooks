class AdminController < ApplicationController
  before_filter :admin_auth
  layout 'user'
  
  def index
    redirect_to :action => 'books'
  end
  
  def books
    @books = Item.find(:all, :order => "id desc")
  end
  
  def add_image
    @item = Item.find(params[:id])
    @photo = Photo.new
    render :layout => false
  end
  
  def update_image
    @item = Item.find(params[:item_id])
    @item.photos.each {|p| p.destroy }
    data = params[:photo][:data]
    @photo = Photo.new
    @photo.item_id = @item.id
    @photo.photo_type = Photo::MAIN
    @photo.file_name = "book#{@item.id}.jpg"
    @photo.url = "/images/books/#{@photo.file_name}"
    @photo.path = "#{RAILS_ROOT}/public#{@photo.url}"
    tf = File.new("#{@photo.path}", "w")
    tf.write params[:photo][:data].read
    tf.close
    data = Image.read(@photo.path).first
    @photo.content_type = data.mime_type
    @photo.bytes = data.filesize
    @photo.height = data.rows
    @photo.width = data.columns
    @photo.caption = @item.name
    @photo.save!
    redirect_to :action => 'books'
  end
  
  def add_book
    @book = Item.new
    @book.generate_tbid_no_save
  end
  
  def create_book
    @book = Item.create(params[:item])
    @book.person_id = NOBODY_USER
    @book.save!
    @change = Change.new
    @change.change_type = Change::ITEM_LOCATION
    @change.effective_date = Time.new
    @change.item_id = @book.id
    @change.new_value = 1
    @change.save!
    redirect_to :action => 'books'
  end
  
  def show_book
    
  end
  
  def edit_book
    @book = Item.find(params[:id])
  end
  
  def update_book
    @item = Item.find(params[:item][:id])
    if @item.update_attributes(params[:item])
      #flash[:notice] = 'Book was successfully updated.'
      redirect_to :action => 'books'
    else
      render :action => 'edit_book', :id => params[:item][:id]
    end
  end
  
  def destroy_book
    Item.find(params[:id]).destroy
    redirect_to :action => 'books'
  end
  
  def people
    
  end
  
  def locations
    
  end
  
  def test_errors
    
  end
  
  def create_sale_item_from_item
    @item = Item.find(params[:id])
    @sale_item = SaleItem.new
    @sale_item.name = @item.name
    @sale_item.description = @item.description
    @sale_item.status = 3
    @sale_item.save!
    render :action => 'edit_sale_item'
  end
  
  def update_sale_item
    @sale_item = SaleItem.find(params[:id])
    if @sale_item.update_attributes(params[:sale_item])
      flash[:notice] = 'SaleItem was successfully updated.'
      redirect_to :controller => 'sale_item', :action => 'list'
    else
      render :action => 'edit_sale_item'
    end
  end
  
  def edit_sale_item
    @sale_item = SaleItem.find(params[:id])
  end
  
end
