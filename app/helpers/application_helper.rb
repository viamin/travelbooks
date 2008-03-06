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
  
  def random_saying
    sayings = ["Disco Heaven", "Kissed Frog", "Dewdrop Sunshine", "Daffodil Meadow", "Yes, This is Random", "Pointless Fun", "The Google Did It", "Google Knows", "John Muir Has Been There", "Full Sails", "Full Steam Ahead", "We All Shine On", "Blue Plate Special"]
    index = rand(sayings.length) - 1
    sayings[index]
  end
  
end
