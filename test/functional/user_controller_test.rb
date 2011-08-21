require 'test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < ActionController::TestCase
  # fixtures :people, :locations

  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = Person.find(:first).id
  end

  def test_index
    session_vals = {:user_id => people(:bart).id}
    get :index, {}, session_vals
    assert_response :redirect
    assert_redirected_to :action => 'home'
  end

  def test_list
    session_vals = {:user_id => people(:bart).id}
    get :list, {:id => @first_id}, session_vals

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:friends)
  end

  def test_show
    session_vals = {:user_id => people(:kat).id}
    get :show, {:id => @first_id}, session_vals

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:person)
    assert assigns(:person).valid?
  end

  def test_new
    session_vals = {:user_id => people(:bart).id}
    get :new, {}, session_vals

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:person)
  end

  def test_edit
    # populates the session hash
    session_vals = {:user_id => people(:bart).id}
    get :edit, {}, session_vals

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:person)
    assert assigns(:person).valid?
  end

  def test_update
    session_vals = {:user_id => people(:bart).id}
    post :update, {:id => @first_id}, session_vals
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Person.find(@first_id)
    }
    session_vals = {:user_id => people(:bart).id}
    post :destroy, {:id => @first_id}, session_vals
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Person.find(@first_id)
    }
  end
  
  def test_join
    post :join, :person => {:email => "test@travellerbook.com", :nickname => "Test User", :password => "test123", :password_confirmation => "test123", :first_name => "TestUser"}, :location => {:country => "United States", :city => "Santa Clara", :state => "CA"}
    assert_equal("Thank you for joining TravellerBook.com.", flash[:notice])
    assert_redirected_to :action => 'home'
    assert_equal(Person.all.length + 1, session[:user_id])
  end
end
