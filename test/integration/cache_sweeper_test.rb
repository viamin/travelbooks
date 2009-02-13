require "#{File.dirname(__FILE__)}/../test_helper"

class CacheSweeperTest < ActionController::IntegrationTest
  fixtures :people, :locations, :changes, :items
  
  def setup
    @person1 = people(:people_001)
    @person2 = people(:people_002)
  end

  def test_friend_cache
    post 'user/login', :person => {:email => 'danny@yahoo.com', :password => 'dsouthard'}
    # The friend cache should be swept whenever people add friends
    assert_cache_fragments(:controller => 'user', :action => 'home', :action_suffix => "friends#{@person1.id}") do
      get 'user/home'
    end
    @message = Message.send_request(@person2, @person1)
    assert_expire_fragments(:controller => 'user', :action => 'home', :action_suffix => "friends#{@person1.id}") do
      post 'user/accept', :message_id => @message.id
    end
  end
  
  private
  
  module MyTestingDSL
    attr_reader :person
    def logs_in_as(person)
      @person = people(person)
      
    end
  end
  
  def new_session_as(person)
    new_session do |sess|
      sess.logs_in_as(person)
      yield sess if block_given?
    end
  end
  
end
=begin
  assert_cache_fragments(:controller => "foo", :action => "bar", :action_suffix => "baz") do
    get "/foo/bar"
  end

== Testing expiration of fragments

To check that your fragments are expired when doing some action,
do

  assert_expire_fragments(:controller => "foo", :action => "bar", :action_suffix => "baz") do
    get "/foo/expire"
  end
=end