# == Schema Information
# Schema version: 29
#
# Table name: destinations
#
#  id          :integer         not null, primary key
#  trip_id     :integer         
#  name        :string(255)     
#  position    :integer         
#  location_id :integer         
#  notes       :text            
#  arrival     :datetime        
#  departure   :datetime        
#  change_id   :integer         
#

class Destination < ActiveRecord::Base
  belongs_to :trip
  has_one :change
  acts_as_list :scope => :trip
  
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
