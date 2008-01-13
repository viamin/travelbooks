class PhotoController < ApplicationController
  before_filter :authorize
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
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
  
  def create
    @person = Person.find(session[:user_id])
    # Filesystem method
    photo = Photo.save(params[:photo], @person)
    # database method
    #@params['photo']['data'] = @params['photo']['data'].read
    #@params['photo'].delete('tmp_file') # let's remove the field from the hash, because there's no such field in the DB anyway.
    #@photo = Photo.create(@params['photo'])
    redirect_to :action => 'list', :id => @person
  end
  
  def update
    @person = Person.find(session[:user_id])
    @photo = Photo.find(params[:photo][:id])
    @photo.make_primary_for_person(@person) if (params[:photo]['is_primary'] == 1)
    params[:photo]['is_primary?'] = nil
    @photo.caption = params[:photo][:caption]
    if @photo.save
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :action => 'list', :id => @person
    else
      render :action => 'edit_details'
    end
  end
  
  def destroy
    photo = Photo.find(params[:id])
    File.delete(photo.path) if File.exist?(photo.path)
    photo.destroy
    redirect_to :action => 'list'
  end
end
