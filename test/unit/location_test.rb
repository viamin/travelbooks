require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Location, locations(:first)
  end
end
