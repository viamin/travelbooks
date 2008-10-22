require File.dirname(__FILE__) + '/../test_helper'

class ShoppingCartTest < ActiveSupport::TestCase
  fixtures :shopping_carts

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ShoppingCart, shopping_carts(:shopping_carts_001)
  end
end
