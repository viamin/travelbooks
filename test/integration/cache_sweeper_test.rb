#require "#{File.dirname(__FILE__)}/../test_helper"
require 'test_helper'

class CacheSweeperTest < ActionController::IntegrationTest
  fixtures :people, :locations, :changes, :items

  def test_friend_cache
    get "http://localhost:3000"
    assert_response :success
    admin = new_session_as(:bart)
    person1 = new_session_as(:nofriends)
    person2 = new_session_as(:nofriends2)
    admin.clears_caches
    assert_cache_fragments(:controller => 'user', :action => 'home', :action_suffix => "friends#{person1.person.id}") do
      person1.goes_home
    end
    # The friend cache should be swept whenever people add friends
    person2.sends_friends_request_to(person1)
    message = Message.find(:first, :conditions => {:sender => person2.id, :person_id => person1.id, :message_type => Message::FRIENDREQUEST})
    assert_expire_fragments(:controller => 'user', :action => 'home', :action_suffix => "friends#{person1.person.id}") do
      post 'user/accept', :message_id => message.id
    end
  end
  
  private
  
  module MyTestingDSL
    attr_reader :person
    def logs_in_as(user)
      @person = people(user)
      timing @person.pretty_inspect
      post 'user/login', :person => {:email => @person.email, :password => user}
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end
    def goes_home
      get 'user/home'
      assert_response :success
    end
    def clears_caches
      get 'admin/cache_purge'
      assert_response :redirect
    end
    def sends_friend_request_to(user)
      post 'user/send_request', :friend_id => user.id
    end
    def accepts_friendship_in_message(message)
      post 'user/accept', :message_id => message.id
    end
  end
  
  def new_session_as(user)
    new_session do |sess|
      sess.logs_in_as(user)
      yield sess if block_given?
    end
  end
  
  def new_session
    open_session do |sess|
      sess.extend(MyTestingDSL)
      yield sess if block_given?
    end
  end
  
end