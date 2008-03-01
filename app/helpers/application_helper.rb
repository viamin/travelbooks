# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def get_person(person_id)
    person = Person.find(:all, :conditions => {:id => person_id})
    if person.empty?
      return Person.new
    else
      return person.first
    end
  end
  
end
