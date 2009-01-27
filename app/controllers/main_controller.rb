class MainController < ApplicationController
  before_filter :check_cookie, :only => [:index]
#  caches_page :about, :faq, :privacy, :site_map

  def index
    render :layout => false
  end

  def about
  end
  
  def faq
  end
  
  def privacy
  end
  
  def site_map
  end
  
end
