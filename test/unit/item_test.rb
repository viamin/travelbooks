require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  fixtures :items, :people

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Item, items(:items_005)
  end
  
  def test_change_owners
    item = Item.find(15)
    new_owner = Person.find(9)
    time = Time.now
    item.change_owner(new_owner, time)
    assert_equal(item.person, new_owner)
#    assert_equal(item.changes.last.effective_date, Date.new(ParseDate.parsedate(time.to_s)))
  end
  
  def test_generate_tbid
    item = Item.create
    item.description = "Test Item"
    item.generate_tbid
    item2 = Item.create
    item2.description = "Test Item"
    item2.generate_tbid
    assert_not_equal(item2.tbid, item.tbid)
  end
  
  def test_get_trail
    item3 = Item.find(14)
    item4 = Item.find(15)
    changes3 = item3.get_trail
    changes4 = item4.get_trail
    assert_equal(changes3.collect{ |change| change.person }, changes4.collect{|change| change.person})
  end
  
  def test_miles_travelled
    #tbd
  end
end
