# == Schema Information
# Schema version: 20
#
# Table name: orders
#
#  id                   :integer         not null, primary key
#  person_id            :integer         
#  shipping_location_id :integer         
#  created_on           :date            
#  shipped_on           :date            
#  paid_on              :date            
#

class Order < ActiveRecord::Base
  belongs_to :person
  belongs_to :location
end
