require File.dirname(__FILE__) + '/../test_helper'
require 'main_controller'

# Re-raise errors caught by the controller.
class MainController; def rescue_action(e) raise e end; end

class MainControllerTest < Test::Unit::TestCase
  fixtures :people

  def setup
    @controller = MainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_tracking
    get :tracking
    assert_response :success
    assert_template 'tracking'
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'home'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:people)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

  #  assert_not_nil assigns(:person)
  #  assert assigns(:person).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:person)
  end

  def test_create
    num_people = Person.count

    post :create, :person => {}

    assert_response :success

  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

  #  assert_not_nil assigns(:person)
  #  assert assigns(:person).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :success
  end

  def test_destroy
    assert_not_nil Person.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Person.find(1)
    }
  end

  def test_join
    get :join, :login  => "Viamin", :password => "rsh56w"
    @person = Person.find(1)
    @location = Location.new
    @location.person_id = @person.id
    #assert_session_has :user_id
  end

  def test_login
  end
end
