require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  def test_retrieve
    @expected.subject = 'UserMailer#retrieve'
    @expected.body    = read_fixture('retrieve')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_retrieve(@expected.date).encoded
  end

  def test_welcome
    @expected.subject = 'UserMailer#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_welcome(@expected.date).encoded
  end

end
