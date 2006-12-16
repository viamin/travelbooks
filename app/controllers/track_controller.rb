class TrackController < ApplicationController
  def index
    if params[:tbook]
      if params[:tbook].length > 0
        redirect_to(:action => 'track')
      end
    else
      redirect_to(:action => 'search')
    end
  end

  def track
    @user = Person.find(session[:user_id])
    @books = Item.find(:all, :conditions => ["code = ?", params[:tbook]])
  end

  def search
    if session[:user_id]
      @user = Person.find(session[:user_id])
    end
  end
  
  def map
    @user = Person.find(session[:user_id])
    @location = Location.find(:first, :conditions => ["person_id = ?", @user.id])
  end
  
end
