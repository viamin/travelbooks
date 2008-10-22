require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  fixtures :people, :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Person, people(:people_007)
  end
  
  def test_id
    assert people(:people_001).first_name == "Bart"
    assert people(:people_001).id == 1
  end
  
  def test_person
    assert_kind_of Person, Person.find(:first)
  end
  
  def test_find
    assert Person.find(:first, ["id = ?", 1]).first_name == "Bart"
  end
  
  def test_login
    person = Person.new
    person.password = "rsh56w"
    person.email = "bart@sonic.net"
    assert_kind_of Person, Person.login(person.login, person.password)
    assert Person.email_login(person.email, person.password) == Person.find(:first, ["id = ?", 1])
  end
  
  def test_latest_location
    person = Person.find(2)
    location1 = Location.find(2)
    location2 = Location.find(1)
    assert_equal(person.locations, [location1, location2])
    assert_equal(person.latest_location, location2)
  end
  
  def test_change_location
    person = Person.find(1)
    new_location = Location.find(2)
    date = Time.now
    person.change_location(new_location, date)
    assert_equal(person.locations.find_all.last, new_location)
#    assert_equal(person.change.last.effective_date, date)
  end
  
end
