# == Schema Information
# Schema version: 30
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
#  departure   :datetime        # deprecating departure
#  change_id   :integer         
#

class Destination < ActiveRecord::Base
  belongs_to :trip
  has_one :change
  acts_as_list :scope => :trip
  validates_presence_of :name
  validates_length_of :name, :maximum => 250
  
  def location
    Location.find(:first, :conditions => {:id => self.location_id})
  end
  
  def location=(value)
    self.location_id = value.id
  end
  
  def has_location?
    unless self.location_id.nil?
      return !(self.location.nil?)
    else
      return false
    end
  end

  def trip
    Trip.find(self.trip_id)
  end
  
  def other_locations
    self.trip.destinations.collect {|d| d.location if d.has_location?}.compact
  end

end
