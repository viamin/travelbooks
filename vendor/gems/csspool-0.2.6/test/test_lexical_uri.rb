require File.dirname(__FILE__) + "/helper"

class LexicalURITest < Test::Unit::TestCase
  include CSS::SAC

  def test_to_s
    first = LexicalURI.new('url(http://tenderlovemaking.com/)')
    assert_equal('url(http://tenderlovemaking.com/)', first.to_s)
  end

  def test_hash
    first = LexicalURI.new('url(http://tenderlovemaking.com/)')
    second = LexicalURI.new('url(http://tenderlovemaking.com/)')
    assert_equal first.hash, second.hash

    third = LexicalURI.new('url(http://www.tenderlovemaking.com/)')
    assert_not_equal first.hash, third.hash
  end

  def test_equals2
    first = LexicalURI.new('url(http://tenderlovemaking.com/)')
    second = LexicalURI.new('url(http://tenderlovemaking.com/)')
    assert_equal first, second

    third = LexicalURI.new('url(http://www.tenderlovemaking.com/)')
    assert_not_equal first, third
  end
end
