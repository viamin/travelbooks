require File.dirname(__FILE__) + '/../test_helper'

class ShoppingCartTest < Test::Unit::TestCase
  fixtures :shopping_carts

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ShoppingCart, shopping_carts(:first)
  end
end
