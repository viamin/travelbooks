class TrackController < ApplicationController
  before_filter :authorize, :except => [:friend, :item]
  
  def index
    if params[:tbook]
      if params[:tbook].length > 0
        redirect_to(:action => 'track')
        return
      end
    else
      redirect_to(:action => 'search')
    end
  end

  def find
    @books = Item.where({:tbid => params[:search_box]})
    if @books.nil? || @books.empty?
      if (params[:search_box].length > 6)
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    else
      @book = @books.first
    end
    render :layout => false
  end
  
  def friend
    @user = Person.find(session[:user_id]) if logged_in?
    search_term = params[:name_search_box]
    @people = Person.where(["email like ?", "%#{search_term.downcase}%"]).concat(Person.where(["nickname like ?", "%#{search_term}%"])).uniq.delete_if {|p| p.email == "noemail@travellerbook.com"} unless (search_term.nil? || search_term == String.new)
#    @people = Person.find(:all, :conditions => {:email => search_term}).concat(Person.find(:all, :conditions => {:nickname => search_term})).uniq
    if (@people.nil? || @people.empty?)
      @message = "No one was found for the search term \"#{search_term}\""
    end
    render :layout => false
  end

  def search
    if session[:user_id]
      @user = Person.find(session[:user_id])
    end
  end
  
  def item
    @books = Item.where({:tbid => params[:tbid]})
    if @books.empty?
      if params[:tbid] && (params[:tbid].length > 6)
        @message = "Nothing found with that code"
      else
        @message = "Invalid code"
      end
    else
      @message = String.new
      @message << "<h3>Search Results</h3>\n"
      @message << "<ul class=\"results_list\">\n"
      @books.each do |book|
      	@message << "\t<li><a href=\"/item/show/#{book.id}\"><img src=\"/item/image/#{book.id}\" width=\"36\" height=\"50\" alt=\"#{book.name}\" />#{book.name}</a></li>\n"
      end
      @message << "</ul>\n"
    end
    render :action => 'search'
  end
  
  def map
    @user = Person.find(session[:user_id])
    @location = Location.where(["person_id = ?", @user.id]).first
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
