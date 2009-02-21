require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  fixtures :people
  
  tests UserMailer
  def test_retrieve
    @expected.subject = 'Your TravellerBook.com password has been reset'
    # Need to figure out how to load a multipart/mime fixture
#    @expected.body    = read_fixture('retrieve')
    @expected.date    = Time.now
    @expected.from    = 'TravellerBooks <do-not-reply@travellerbook.com>'

    @person = people(:barttest)
    # Need to figure out how to do this with multipart/mime
#    assert_equal @expected.encoded, UserMailer.create_retrieve(@person, "password").encoded
  end

end
