# == Schema Information
# Schema version: 26
#
# Table name: destinations
#
#  id          :integer         not null, primary key
#  vacation_id :integer         
#  name        :string(255)     
#  position    :integer         
#  location_id :integer         
#  notes       :text            
#  arrival     :datetime        
#  departure   :datetime        
#

class Destination < ActiveRecord::Base
  belongs_to :vacation
  acts_as_list :scope => :vacation
  
  def location
    Location.find(self.location_id)
  end
  
  def location=(value)
    self.location_id = value.id
  end
  
  def has_location?
    if self.location_id
      return !(self.location.nil?)
    else
      return false
    end
  end
  
end
