# == Schema Information
# Schema version: 20090214004612
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
  has_many :destinations, :order => :position do
    def with_locations
      proxy_target.delete_if {|destination| destination.no_location?}.compact! || proxy_target
    end
  end
  has_and_belongs_to_many :items
  validates_length_of :name, :maximum => 250, :message => "must be less than 250 characters please"
#  validates_length_of :companions, :maximum => 250, :message => "must be less than 250 characters please"
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.name = String.new if self.name.nil?
      self.companions = String.new if self.companions.nil?
    end
  end
  
  def person
    Person.find(self.person_id) unless self.person_id.nil?
  end
  
  def item
    Item.find(self.item_id) unless self.item_id.nil?
  end
end
