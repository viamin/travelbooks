require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :people

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
    assert_kind_of Person, person.try_to_login
    assert person.try_to_login == Person.find(:first, ["id = ?", 1])
    assert_nil person.try_email_login
  end
end
