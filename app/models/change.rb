# == Schema Information
# Schema version: 13
#
# Table name: changes
#
#  id             :integer       not null, primary key
#  change_type    :integer       default(0)
#  item_id        :integer       default(0)
#  person_id      :integer       default(0)
#  location_id    :integer       default(0)
#  old_value      :string(255)   default(NULL)
#  new_value      :string(255)   default(NULL)
#  effective_date :date          
#  created_on     :date          
#

#Need to decide if location_id is necessary

class Change < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  belongs_to :location
  
  # possible change_types:
  OWNERSHIP = 1
  PERSON_LOCATION = 2
  
  # allow change types to be read from outside the class
  attr_reader :OWNERSHIP
  attr_reader :PERSON_LOCATION
  
end
