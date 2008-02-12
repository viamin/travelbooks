class AdminController < ApplicationController
  before_filter :admin_auth
  layout 'user'
  
  def index
    redirect_to :action => 'books'
  end
  
  def books
    @books = Item.find(:all)
  end
  
  def add_image
    @item = Item.find(params[:id])
    @photo = Photo.new
    render :layout => false
  end
  
  def update_image
    @item = Item.find(params[:item_id])
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
