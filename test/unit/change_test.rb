require File.dirname(__FILE__) + '/../test_helper'

class ChangeTest < ActiveSupport::TestCase
  fixtures :changes

  def setup
    @change = Change.find(:first)
  end

  # Replace this with your real tests.
  def test_is_identical_to
    assert @change.is_identical_to?(@change.dup)
  end
end
