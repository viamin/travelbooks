require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Location, locations(:locations_003)
  end
end
