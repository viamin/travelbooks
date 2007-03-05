require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :people, :locations

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Person, people(:first)
  end
  
  def test_id
    assert people(:first).first_name == "Bart"
    assert people(:first).id == 1
  end
  
  def test_person
    assert_kind_of Person, Person.find(:first)
  end
  
  def test_find
    assert Person.find(:first, ["id = ?", 1]).first_name == "Bart"
  end
  
  def test_login
    person = Person.new
    person.login = "Viamin"
    person.password = "rsh56w"
    person.email = "bart@sonic.net"
    assert_kind_of Person, Person.login(person.login, person.password)
    assert Person.login(person.login, person.password) == Person.find(:first, ["id = ?", 1])
    assert Person.email_login(person.email, person.password) == Person.find(:first, ["id = ?", 1])
  end
  
  def test_age
    person = Person.find(1)
    assert_equal(29, person.age)
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
    assert_equal(person.locations.last, new_location)
#    assert_equal(person.change.last.effective_date, date)
  end
  
end
