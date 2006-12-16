require File.dirname(__FILE__) + '/../test_helper'

class CreditCardTest < Test::Unit::TestCase
  fixtures :credit_cards

  # Replace this with your real tests.
  def test_truth
    assert_kind_of CreditCard, credit_cards(:first)
  end
end
