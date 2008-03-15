require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  def test_retrieve
    @expected.subject = 'UserMailer#retrieve'
    @expected.body    = read_fixture('retrieve')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_retrieve(@expected.date).encoded
  end

end
