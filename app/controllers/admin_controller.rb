class AdminController < ApplicationController
  before_filter :admin_auth, :except => [:cleanup, :index]
  layout 'user'
  
  def index
    
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
    @item.add_new_location_change = params[:item][:add_new_location_change]
    params[:item].delete_if {|key, value| key == "add_new_location_change"}
    timing params[:item].pretty_inspect
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
  
  def create_sale_item_from_item
    @item = Item.find(params[:id])
    @sale_item = SaleItem.new
    @sale_item.name = @item.name
    @sale_item.description = @item.description
    render :action => 'new'
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
  
  # This method will cleanup broken links. It will sweep through the changes table looking for stale entries and remove them. 
  def cleanup
    # first, remove any duplicates
    Change.remove_duplicates
    Location.remove_duplicates
    # next, find any changes that reference people or places that no longer exist
    @changes = Change.find(:all)
    @changes.each do |change|
      case change.change_type
      when Change::OWNERSHIP
        person = Person.find(:all, :conditions => {:id => change.new_value})
        timing "Will destroy OWNERSHIP change #{change.pretty_inspect}" if person.empty?
        change.destroy if person.empty?
      when Change::PERSON_LOCATION
        location = Location.find(:all, :conditions => {:id => change.new_value})
        timing "Will destroy PERSON_LOCATION change #{change.pretty_inspect}" if location.empty?
        change.destroy if location.empty?
      when Change::PERSON_MAIN_LOCATION
        location = Location.find(:all, :conditions => {:id => change.new_value})
        timing "Will destroy PERSON_MAIN_LOCATION change #{change.pretty_inspect}" if location.empty?
        change.destroy if location.empty?
      when Change::ITEM_LOCATION
        location = Location.find(:all, :conditions => {:id => change.new_value})
        timing "Will destroy ITEM_LOCATION change #{change.pretty_inspect}" if location.empty?
        change.destroy if location.empty?
      end
    end
    # next, find any locations that aren't referenced by changes, people, or anywhere else there is a location_id field
    @locations = Location.find(:all)
    @locations.each do |location|
      @location_info_changed = false
      loc_check = location.used_anywhere?
      timing "Will destroy Location #{location.description}" unless loc_check
      location.destroy unless loc_check
      person_array = Person.find(:all, :conditions => {:id => location.person_id})
      if person_array.empty? && !location.person_id.nil?
        location.person_id = nil
        timing "Will remove person info from Location #{location.description}"
        @location_info_changed = true
      end
      item_array = Item.find(:all, :conditions => {:id => location.item_id})
      if item_array.empty? && !location.item_id.nil?
        location.item_id = nil
        timing "Will remove item info from Location #{location.description}"
        @location_info_changed = true
      end
      location.save if @location_info_changed
    end
    # Clean up friends table - make sure everyone exists
    @friends = Friend.find(:all)
    @friends.each do |friend|
      friend.destroy unless Person.find(:first, :conditions => {:id => friend.owner_person_id}).kind_of?(Person)
      friend.destroy unless Person.find(:first, :conditions => {:id => friend.entry_person_id}).kind_of?(Person)
    end
    # Clean up messages to and from users that don't exist
    timing "Checking messages for valid senders and recipients"
    @messages = Message.find(:all)
    @messages.each do |message|
      message.destroy unless Person.find(:first, :conditions => {:id => message.person_id}).kind_of?(Person)
      message.destroy unless Person.find(:first, :conditions => {:id => message.sender}).kind_of?(Person)
    end
    flash[:notice] = "Cleaned up the database"
    redirect_to :action => 'index'
  end
  
  def users
    @users = Person.find(:all)
  end
  
  def edit_user
    @user = Person.find(params[:id])
    reset_session
    session[:user_id] = @user.id
    redirect_to :controller => 'user', :action => 'edit'
  end
  
  def destroy_user
    Person.find(params[:id]).destroy
    flash[:notice] = "You'll probably want to run cleanup now"
    redirect_to :action => 'users'
  end
  
  def locations
    @locations = Location.find(:all)
  end
  
  def test_email
    @person = Person.new
    @person.email = "info@travellerbook.com"
    UserMailer.deliver_welcome(@person)
    flash[:notice] = "A test email has been sent to #{@person.email}"
    redirect_to :action => 'index'
  end
  
  def friends
    @users = Person.find(:all)
    @messages = Message.find(:all, :conditions => {:message_type => Message::FRIENDREQUEST})
  end
  
  def mark_message
    @message = Message.find(params[:message_id])
    if params[:mark] == "unread"
      @message.mark_unread!
    end
    if params[:mark] == "undelete"
      @message.undelete!
    end
    redirect_to :action => 'friends'
  end
  
  def trips
    @trips = Trip.find(:all)
  end
  
end
