class TrackController < ApplicationController
  before_filter :authorize
  
  def index
    if params[:tbook]
      if params[:tbook].length > 0
        redirect_to(:action => 'track')
      end
    else
      redirect_to(:action => 'search')
    end
  end

  def find
    @user = Person.find(session[:user_id])
    @books = Item.find(:all, :conditions => {:tbid => params[:search_box]})
    if @books.empty?
      if params[:search_box].length > 6
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    end
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
  
  # new will allow a user to find a book and add it to his or her trail
  def new
    if session[:user_id]
      @user = Person.find(session[:user_id])
    end
    session[:current_action] = :user_add_item
    render :action => 'search'
  end
  
end
