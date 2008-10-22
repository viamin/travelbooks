require File.dirname(__FILE__) + '/../test_helper'

class CreditCardTest < ActiveSupport::TestCase
  fixtures :credit_cards

  def test_truth
    assert_kind_of CreditCard, credit_cards(:credit_cards_001)
  end

end
