# == Schema Information
# Schema version: 12
#
# Table name: changes
#
#  id             :integer       default(0), not null, primary key
#  change_type    :integer       default(0)
#  item_id        :integer       default(0)
#  person_id      :integer       default(0)
#  old_value      :string(255)   default()
#  new_value      :string(255)   default()
#  effective_date :date          
#  created_on     :date          
#

class Change < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  
  # Not sure how to do this correctly, so I'll do it the weird way
  def OWNERSHIP
    1
  end
  
  def PERSON_LOCATION
    2
  end
end
