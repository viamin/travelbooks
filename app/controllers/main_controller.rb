class MainController < ApplicationController

  def index
    session[:current_action] = nil
    render :layout => false
  end

  def about
  end
  
  def faq
  end
  
end
