require "#{File.dirname(__FILE__)}/../test_helper"

class UsersTest < ActionController::IntegrationTest
  fixtures :people, :locations, :changes, :items, :friends

  # Change below for correct controller/actions
  def test_signup_new_person
    get "/user/login"
    assert_response :success
    assert_template "user/login"

    get "/user/join"
    assert_response :success
    assert_template "user/join"

    post "/user/join", :name => "Bob", :user_name => "bob",
      :password => "secret"
    assert_response :success
    assert_template "user/join"
  end
end