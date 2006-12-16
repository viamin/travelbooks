require File.dirname(__FILE__) + '/../test_helper'

class LocationsTest < Test::Unit::TestCase
  fixtures :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Locations, locations(:first)
  end
end
