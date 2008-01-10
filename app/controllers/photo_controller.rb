class PhotoController < ApplicationController
  before_filter :authorize
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  def list
    @person = Person.find(params[:id])
    if @person == Person.find(session[:user_id])
      redirect_to :action => 'edit'
    end
    @photos = @person.photos
    @message = "No photos have been uploaded" if @photos.length == 0
  end
  
  def show
    @photo = Photo.find(params[:id])
  end
  
  def new
  end
  
  def edit
    @person = Person.find(params[:id])
    @photos = @person.photos
    @message = "No photos have been uploaded" if @photos.length == 0
  end
  
  def create
    @person = Person.find(session[:user_id])
    
    # Handle File uploads here
    redirect_to :action => 'list', :id => @person
  end
  
  def update
    
  end
  
  def destroy
    
  end
end
