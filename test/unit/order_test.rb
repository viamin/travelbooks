require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < ActiveSupport::TestCase
  fixtures :orders

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Order, orders(:orders_001)
  end
end
