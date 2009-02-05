require "#{File.dirname(__FILE__)}/../test_helper"

class CacheSweeperTest < ActionController::IntegrationTest
  fixtures :people, :locations, :changes, :items
  
  def setup
    @person1 = people(:people_001)
    @person2 = people(:people_002)
    session[:user_id] = @person1.id
  end

  def test_friend_cache_sweep
    # The friend cache should be swept whenever people add friends
    get 'user/home'
    assert_response :success
    
  end
  
  private
  
  module myTestingDSL
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
