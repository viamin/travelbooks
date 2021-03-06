class ItemsController < ApplicationController
  before_filter :authorize, :except => [:image]
  cache_sweeper :item_sweeper, :only => [:associate]
  
  def index
    redirect_to :action => 'list'
  end

  def list
    if params[:id].blank?
      redirect_to :controller => 'user', :action => 'home'
      return
    end
    @person = Person.find(params[:id])
    @location = @person.current_location
    @items = @person.all_items
    @current_items = @person.items
    @old_items = @items - @current_items
    # @map = Mapstraction.new("item_map", MAP_TYPE)
    # @map.control_init(:small => true)
    # @map.center_zoom_init([@location.lat, @location.lng],10)
    # @map.marker_init(Marker.new([@location.lat, @location.lng], :icon => '/images/homeicon.png'))
    @json = @location.to_gmaps4rails
  	@items.each do |i|
  	  il = i.locations.current
  	  # @map.marker_init(Marker.new([il.lat, il.lng], :info_bubble => i.name, :icon => "/images/ambericonsh.png"))
	  end
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
    # @map = Mapstraction.new("item_map", MAP_TYPE)
    # @map.control_init(:small => true)
    # @map.center_zoom_init([@loc.lat, @loc.lng],10)
    # @map.marker_init(Marker.new([@loc.lat, @loc.lng], :icon => "/images/ambericonsh.png"))
    @json = @loc.to_gmaps4rails
    # @points = @item.locations.sorted.collect{ |p| LatLonPoint.new([p.lat, p.lng])}
    # @line = Polyline.new(@points, :width => 5, :color => "#FF00AB", :opacity => 0.8)
  	# @map.polyline_init(@line)
#  	render :layout => 'user'
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
    thumb = params[:thumb].to_i
    # Need to decide if I'll be grabbing images from the hard drive or out of the DB
    main_photo = item.photos.main
    unless main_photo.nil?
      if (main_photo.url == "db")
        send_data(main_photo.data,
              :disposition => 'inline',
              :type => main_photo.content_type,
              :filename => main_photo.file_name)
      else
        if ([18, 36, 80].include?(thumb) && File.exists?("#{Rails.root}/public#{main_photo.thumb_url(thumb)}"))
          filename = "#{Rails.root}/public#{main_photo.thumb_url(thumb)}"
        else
          filename = "#{Rails.root}/public#{main_photo.url}"
        end
        FileUtils.touch filename
        send_file(filename,
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
