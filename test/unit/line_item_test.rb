require File.dirname(__FILE__) + '/../test_helper'

class LineItemTest < Test::Unit::TestCase
  fixtures :line_items

  # Replace this with your real tests.
  def test_truth
    assert_kind_of LineItem, line_items(:first)
  end
end
