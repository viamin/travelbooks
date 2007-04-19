class ItemController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @item_pages, @items = paginate :items, :per_page => 10
  end

  def show
    @item = Item.find_by_tbid(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = 'Item was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = 'Item was successfully updated.'
      redirect_to :action => 'show', :id => @item
    else
      render :action => 'edit'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def image
    item = Item.find_by_tbid(params[:id])
    # Need to decide if I'll be grabbing images from the hard drive or out of the DB
    photos = item.photos
    main_photo = photos.detect(photos.first) { |p| p.is_primary? }
    if (main_photo.url == "db")
      send_data(main_photo.data,
              :disposition => 'inline',
              :type => main_photo.content_type,
              :filename => main_photo.file_name)
    else
      send_file("#{main_photo.path}/#{main_photo.file_name}",
                :disposition => 'inline',
                :type => main_photo.content_type,
                :file_name => main_photo.file_name)
    end
  end
  
  def associate
    @item = Item.find_by_tbid(params[:id])
    unless session[:current_action] == :user_add_item
      flash[:notice] = "You need to log in to add a book to your library"
      session[:item_last_viewed] = @item.tbid
      redirect_to :action => 'login', :controller => 'user'
      return
    end
    
  end
end
