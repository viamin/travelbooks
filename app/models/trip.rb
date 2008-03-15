# == Schema Information
# Schema version: 30
#
# Table name: trips
#
#  id         :integer         not null, primary key
#  name       :string(255)     
#  person_id  :integer         
#  start_date :date            
#  end_date   :date            
#  companions :string(255)     
#  item_id    :integer         
#

class Trip < ActiveRecord::Base
  belongs_to :person
  has_many :destinations, :order => :position
  has_and_belongs_to_many :items
  validates_length_of :name, :maximum => 250
  validates_length_of :companions, :maximum => 250
  
  def person
    Person.find(self.person_id) unless self.person_id.nil?
  end
end
