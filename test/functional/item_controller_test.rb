require File.dirname(__FILE__) + '/../test_helper'
require 'item_controller'

# Re-raise errors caught by the controller.
class ItemController; def rescue_action(e) raise e end; end

class ItemControllerTest < Test::Unit::TestCase
  fixtures :items, :people

  def setup
    @controller = ItemController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = items(:items_005).id
  end

  def test_index
    session_vals = {:user_id => people(:bart).id}
    get :index, {:id => people(:bart).id}, session_vals
    assert_redirected_to :action => 'list'
  end

  def test_list
    session_vals = {:user_id => people(:bart).id}
    get :list, {:id => people(:bart).id}, session_vals

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:items)
  end

  def test_show
    session_vals = {:user_id => people(:bart).id}
    get :show, {:id => @first_id}, session_vals

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:item)
    assert assigns(:item).valid?
  end

  def test_new
    session_vals = {:user_id => @first_id}
    get :new, {}, session_vals

    assert_redirected_to :controller => 'user', :action => 'home'
  end

  def test_create
    num_items = Item.count
    @item = Item.new
    @item.generate_tbid_no_save
    session_vals = {:user_id => people(:bart).id}
    post :create, {:item => {:tbid => @item.tbid}}, session_vals

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_items + 1, Item.count
  end

  def test_edit
    session_vals = {:user_id => people(:bart).id}
    get :edit, {:id => @first_id}, session_vals
    
    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:item)
    assert assigns(:item).valid?
  end

  def test_update
    session_vals = {:user_id => people(:bart).id}
    post :update, {:id => @first_id}, session_vals
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Item.find(@first_id)
    }
    session_vals = {:user_id => people(:bart).id}
    post :destroy, {:id => @first_id}, session_vals
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Item.find(@first_id)
    }
  end
end
