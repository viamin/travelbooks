# == Schema Information
# Schema version: 27
#
# Table name: vacations
#
#  id         :integer         not null, primary key
#  name       :string(255)     
#  person_id  :integer         
#  start_date :date            
#  end_date   :date            
#  companions :string(255)     
#

class Trip < ActiveRecord::Base
  table 'vacations'
  belongs_to :person
  has_many :destinations, :order => :position
end
