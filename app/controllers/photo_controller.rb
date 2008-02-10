class PhotoController < ApplicationController
  before_filter :authorize
  layout 'user'
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  def list
    @person = Person.find(params[:id])
    if @person == Person.find(session[:user_id])
      redirect_to :action => 'edit', :id => @person
    end
    @photos = @person.photos
    @message = "No photos have been uploaded" if @photos.length == 0
  end
  
  def show
    @photo = Photo.find(params[:id])
  end
  
  def new
    @person = Person.find(session[:user_id])
  end
  
  def edit
    @person = Person.find(params[:id])
    @photos = @person.photos
    @message = "No photos have been uploaded" if @photos.length == 0
  end
  
  def edit_details
    @photo = Photo.find(params[:id])
    @person = Person.find(session[:user_id])
  end
  
  # This experimental action is for editing a photo before saving to filesystem or database
  def prepare
    @person = Person.find(session[:user_id])
    #@photo = Photo.new(params[:photo])
    @photo = Photo.save_temp(params[:photo])
    if (@photo.width > 240 || @photo.height > 360)
      @submit_message = "Crop and save photo"
    else
      @submit_message = "Sumbit photo"
    end
  end
  
  def create
    @person = Person.find(session[:user_id])
    photo_params = {:offset_x => params[:offset_x], :offset_y => params[:offset_y], :scale => params[:scale], :caption => params[:caption], :photo_type => params[:photo_type], :file_name => params[:file_name]}
    Photo.save(photo_params, @person)
    
    # Filesystem method
    #photo = Photo.save(params[:photo], @person)
    # database method
    #@params['photo']['data'] = @params['photo']['data'].read
    #@params['photo'].delete('tmp_file') # let's remove the field from the hash, because there's no such field in the DB anyway.
    #@photo = Photo.create(@params['photo'])
    redirect_to :action => 'list', :id => @person
  end
  
  def make_primary
    @photo = Photo.find(params[:id])
    @person = Person.find(session[:user_id])
    @photo.make_primary_for_person(@person)
    redirect_to :action => 'edit', :id => @person
  end
  
  def update
    @person = Person.find(session[:user_id])
    @photo = Photo.find(params[:photo][:id])
    @photo.caption = params[:photo][:caption]
    if params[:photo][:is_primary] == 1
      @photo.make_primary_for_person(@person)
    end
    if @photo.save
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :action => 'list', :id => @person
    else
      render :action => 'edit_details'
    end
  end
  
  def destroy
    photo = Photo.find(params[:id])
    @person = Person.find(session[:user_id])
    File.delete(photo.path) if File.exist?(photo.path)
    photo.destroy
    redirect_to :action => 'list', :id => @person
  end
end
