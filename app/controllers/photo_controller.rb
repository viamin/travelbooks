class PhotoController < ApplicationController
  before_filter :authorize
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  def list
    @person = Person.find(params[:id])
    @photos = @person.photos
  end
  
  def show
    @photo = Photo.find(params[:id])
  end
  
  def new
    
  end
  
  def edit
    @person = Person.find(params[:id])
    @photos = @person.photos
  end
  
  def create
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
end