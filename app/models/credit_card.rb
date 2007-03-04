# == Schema Information
# Schema version: 11
#
# Table name: credit_cards
#
#  id                  :integer       not null, primary key
#  person_id           :integer       default(0)
#  card_type           :string(255)   default(NULL)
#  billing_location_id :integer       default(0)
#  name_on_card        :string(255)   default(NULL)
#  card_number         :string(255)   default(NULL)
#  expiration_date     :date          
#  ccv                 :string(255)   default(NULL)
#  created_on          :date          
#

class CreditCard < ActiveRecord::Base
  belongs_to :person
  has_one :location
  
  def billing_address
    self.location
  end
  
  def billing_address=(value)
    self.location = value
  end
end
