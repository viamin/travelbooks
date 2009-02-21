require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  fixtures :people, :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Person, people(:barttest)
  end
  
  def test_id
    assert people(:bart).first_name == "Bart"
    assert people(:bart).id == 1
  end
  
  def test_person
    assert_kind_of Person, Person.find(:first)
  end
  
  def test_find
    assert Person.find(:first, ["id = ?", 1]).first_name == "Bart"
  end
  
  def test_login
    person = Person.new
    person.password = "bart"
    person.email = "bart@sonic.net"
    assert_kind_of Person, Person.email_login(person.email, person.password)
    assert Person.email_login(person.email, person.password) == Person.find(:first, ["id = ?", 1])
  end
  
  def test_latest_location
    person = Person.find(1)
    location1 = Location.find(1)
    location2 = Location.find(9)
    assert_equal(person.all_locations, [location1, location2])
    assert_equal(person.latest_location, location2)
  end
  
  def test_change_location
    person = Person.find(1)
    new_location = locations(:locations_014)
    date = Time.now
    person.change_location(new_location, date)
    person.reload
    assert_equal(person.all_locations.last, new_location)
#    assert_equal(person.change.last.effective_date, date)
  end
  
end
