class VacationController < ApplicationController
  before_filter :authorize
  layout 'user'
  
  # RESTful actions:
  # Get: list, show, new, edit
  # Post: create
  # Put: update
  # Delete: destroy
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def new
    @person = Person.find(session[:user_id])
    
  end
  
  def edit
    @person = Person.find(session[:user_id])
    @vacation = Vacation.find(params[:id])
  end
  
  def create
    @person = Person.find(session[:user_id])
    @vacation = Vacation.create(params[:vacation])
    @person.vacations << @vacation
    @person.save!
    redirect_to :action => 'list'
  end
  
  def destroy
    @person = Person.find(session[:user_id])
    
  end
  
  def update
    @person = Person.find(session[:user_id])
    
  end
  
  def list
    @person = Person.find(session[:user_id])
    @vacations = @person.vacations
    
  end
  
end
