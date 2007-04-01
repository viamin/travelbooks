require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  fixtures :people, :locations

  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = Person.find(:first)
  end

  def test_index
    get :index
    assert_response :redirect
    assert_redirected_to :action => 'home'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:people)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:person)
    assert assigns(:person).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:person)
  end

  def test_edit
    # populates the session hash
    post :login, :person => {:login => "Viamin", :password => "rsh56w"}
    get :edit

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:person)
    assert assigns(:person).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Person.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Person.find(@first_id)
    }
  end
  
  def test_join
    person = Person.find(1)
    location = Location.find(1)
    assert_nothing_raised { Person.find(1).destroy }
    assert_nothing_raised { Location.find(1).destroy }
    post :join, :person => {:first_name => "Bart"}, :location => {:country => "United States", :city => "Santa Clara", :state => "CA"}
    assert_response :redirect
    assert_equal("Thank you for joining TravellerBook.com", flash[:notice])
    assert_redirected_to :home
    assert_equal("5", session[:user_id])
  end
end
