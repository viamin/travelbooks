require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  fixtures :people
  
  tests UserMailer
  def test_retrieve
    @expected.subject = 'Your TravellerBook.com password has been reset'
    @expected.body    = read_fixture('retrieve')
    @expected.date    = Time.now

    @person = people(:people_007)
    assert_equal @expected.encoded, UserMailer.create_retrieve(@person, "password").encoded
  end

end
