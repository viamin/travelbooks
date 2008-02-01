class TrackController < ApplicationController
  before_filter :authorize, :except => [:find, :friend]
  
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
    @user = Person.find(session[:user_id]) if logged_in?
    @books = Item.find(:all, :conditions => {:tbid => params[:search_box]})
    if @books.empty?
      if (params[:tbid].length > 6)
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    end
  end
  
  def friend
    @user = Person.find(session[:user_id]) if logged_in?
    search_term = params[:search_box]
    @people = Person.find(:all, :conditions => {:email => search_term}).concat(Person.find(:all, :conditions => {:nickname => search_term})).uniq
    if @people.empty?
      @message = "No one was found for the search term: #{search_term}"
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
  
  private
  
  def logged_in?
    !( session.nil? || (session[:user_id].nil?))
  end
  
end
