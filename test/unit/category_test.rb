require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase
  fixtures :categories

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Category, categories(:categories_001)
  end
end
