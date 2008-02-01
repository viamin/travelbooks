# == Schema Information
# Schema version: 22
#
# Table name: changes
#
#  id             :integer         not null, primary key
#  change_type    :integer         
#  item_id        :integer         
#  person_id      :integer         
#  location_id    :integer         
#  old_value      :string(255)     
#  new_value      :string(255)     not null
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
  PERSON_MAIN_LOCATION = 3
  ITEM_LOCATION = 4
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.old_value = String.new if self.old_value.nil?
      self.new_value = String.new if self.new_value.nil?
    end
  end
  
end
