require File.dirname(__FILE__) + '/../test_helper'

class SaleItemTest < Test::Unit::TestCase
  fixtures :sale_items

  # Replace this with your real tests.
  def test_truth
    assert_kind_of SaleItem, sale_items(:first)
  end
end
