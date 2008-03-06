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
    @person = Person.find(params[:id])
    @location = @person.current_location
    @items = @person.all_items
    @map = Mapstraction.new("item_map",:yahoo)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@location.lat, @location.lng],10)
  	@map.marker_init(Marker.new([@location.lat, @location.lng], :icon => '/images/homeicon.png'))
  	@items.each do |i|
  	  il = i.locations.current
  	  @map.marker_init(Marker.new([il.lat, il.lng], :info_bubble => i.name, :icon => "/images/ambericonsh.png"))
	  end
    render :layout => 'user'
  end

  def show
    timing session.pretty_inspect
    @item = Item.find(params[:id])
    if session[:user_id]
      @person = Person.find(session[:user_id])
      if @person.items.include?(@item)
        @message = "<p><a href=\"/item/giveaway/#{@item.id}\"  onclick=\"return confirm('This will remove this book from your item list. You can find this item again in your &quot;All Items&quot; list.');\">I've given this book away</a></p>"
      elsif (session[:last_action] =~ /^track_(find|item)$/)
        @message = "<p>Do you have this book? To add it to your library, click <a href=\"/item/associate/#{@item.id}\">here</a></p>"
      end
    end
    @loc = @item.locations.current
    @map = Mapstraction.new("item_map",:yahoo)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@loc.lat, @loc.lng],10)
  	@map.marker_init(Marker.new([@loc.lat, @loc.lng], :icon => "/images/ambericonsh.png"))
  	@points = @item.locations.sorted.collect{ |p| LatLonPoint.new([p.lat, p.lng])}
  	@line = Polyline.new(@points, :width => 5, :color => "#FF00AB", :opacity => 0.8)
  	@map.polyline_init(@line)
  	@owners = @item.people.owners
  	render :layout => 'user'
  end
  
  def giveaway
    @item = Item.find(params[:id])
    @item.change_owner(Person.find(NOBODY_USER))
    redirect_to :action => 'show', :id => @item.id
  end

  def new
    @item = Item.new
    redirect_to :controller => 'user', :action => 'home'
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
    item = Item.find(params[:id])
    # Need to decide if I'll be grabbing images from the hard drive or out of the DB
    main_photo = item.photos.find(:first, :conditions => {:photo_type => Photo::ITEM, :item_id => item.id})
    unless main_photo.nil?
      if (main_photo.url == "db")
        send_data(main_photo.data,
              :disposition => 'inline',
              :type => main_photo.content_type,
              :filename => main_photo.file_name)
      else
        send_file("#{main_photo.path}",
                :disposition => 'inline',
                :type => main_photo.content_type,
                :file_name => main_photo.file_name)
      end
    else
      # send "no photo" image
      send_file("public/images/no_image.png",
              :disposition => 'inline',
              :type => 'image/png',
              :file_name => 'no_image.png')
    end      
  end
  
  def associate
    @item = Item.find(params[:id])
    @person = Person.find(session[:user_id])
    @change = Change.new
    @change.change_type = Change::OWNERSHIP
    @change.item = @item
    @change.old_value = @item.person_id
    @change.new_value = session[:user_id]
    @change.effective_date = Time.now
    @change.save!
    @person.items << @item
    flash[:notice] = "This item (#{@item.name}) has been added to your library."
    redirect_to :action => 'home', :controller => 'user'
    
  end
end
