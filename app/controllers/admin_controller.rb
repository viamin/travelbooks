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
    @photo.photo_type = Photo::ITEM
    @photo.file_name = "book#{@item.tbid}.jpg"
    @photo.url = "/images/books/#{@photo.file_name}"
    @photo.path = "public#{@photo.url}"
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
      flash[:notice] = 'Book was successfully updated.'
      redirect_to :action => 'books'
    else
      render :action => 'edit_book', :id => params[:id]
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
  
end
