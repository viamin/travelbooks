class TrackController < ApplicationController
  before_filter :authorize, :except => [:friend, :item]
  layout 'user'
  
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
    @books = Item.find(:all, :conditions => {:tbid => params[:search_box]})
    if @books.empty?
      if (params[:tbid].length > 6)
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    end
    render :layout => false
  end
  
  def friend
    @user = Person.find(session[:user_id]) if logged_in?
    search_term = params[:search_box]
    @people = Person.find(:all, :conditions => ["email like ?", "%#{search_term.downcase}%"]).concat(Person.find(:all, :conditions => ["nickname like ?", "%#{search_term}%"])).uniq.delete_if {|p| p.email == "noemail@travellerbook.com"}
#    @people = Person.find(:all, :conditions => {:email => search_term}).concat(Person.find(:all, :conditions => {:nickname => search_term})).uniq
    if @people.empty?
      @message = "No one was found for the search term: #{search_term}"
    end
    render :layout => false
  end

  def search
    if session[:user_id]
      @user = Person.find(session[:user_id])
    end
  end
  
  def item
    @books = Item.find(:all, :conditions => {:tbid => params[:tbid]})
    if @books.empty?
      if (params[:tbid].length > 6)
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    else
      @message = String.new
      @message << "<h3>Search Results</h3>\n"
      @message << "<ul class=\"results_list\">\n"
      @books.each do |book|
      	@message << "\t<li><a href=\"/item/show/#{book.tbid}\">#{book.name}</a></li>\n"
      end
      @message << "</ul>\n"
    end
    render :action => 'search'
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
    render :action => 'search'
  end
  
  private
  
  def logged_in?
    !( session.nil? || (session[:user_id].nil?))
  end
  
end
