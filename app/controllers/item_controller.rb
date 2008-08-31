class ItemController < ApplicationController
  before_filter :authorize, :except => [:image]
  
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
    @current_items = @person.items
    @old_items = @items - @current_items
    @map = Mapstraction.new("item_map", MAP_TYPE)
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
    @item = Item.find(params[:id])
    @owners = Array.new
    if session[:user_id]
      @person = Person.find(session[:user_id])
      if @person.all_items.include?(@item)
        @owners = @item.people.owners.uniq.delete_if {|p| p.id == session[:user_id]}
      elsif (session[:last_action] =~ /^track_(find|item)$/)
        @message = "<p>Do you have this book? To add it to your library, click <a href=\"/item/associate/#{@item.id}\">here</a></p>"
      end
    end
    @loc = @item.locations.current
    @map = Mapstraction.new("item_map", MAP_TYPE)
  	@map.control_init(:small => true)
  	@map.center_zoom_init([@loc.lat, @loc.lng],10)
  	@map.marker_init(Marker.new([@loc.lat, @loc.lng], :icon => "/images/ambericonsh.png"))
  	@points = @item.locations.sorted.collect{ |p| LatLonPoint.new([p.lat, p.lng])}
  	@line = Polyline.new(@points, :width => 5, :color => "#FF00AB", :opacity => 0.8)
  	@map.polyline_init(@line)
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
    main_photo = item.photos.main
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
    @change.new_value = @person.id
    @change.effective_date = Time.now
    @change.save!
    @person.items << @item
    @item.person_id = @person.id
    @item.save!
    # Need to add ability to add giver of book to friends here, need to add book move change here as well
    @loc_change = Change.new
    @loc_change.change_type = Change::ITEM_LOCATION
    @loc_change.person = @person
    @loc_change.item = @item
    @loc_change.old_value = @change.old_person.main_location unless @change.old_person.nil?
    @loc_change.new_value = @person.main_location.id
    @loc_change.effective_date = @change.effective_date
    @loc_change.save!
    session[:entered_tbid] = nil
    if (@change.old_value.nil? || @person.is_friend?(@change.old_person))
      flash[:notice] = "The item (#{@item.name}) has been added to your library."
      redirect_to :action => 'home', :controller => 'user'
    end
  end

end
