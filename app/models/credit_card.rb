# == Schema Information
# Schema version: 31
#
# Table name: credit_cards
#
#  id                          :integer         not null, primary key
#  person_id                   :integer         
#  card_type                   :string(255)     not null
#  name_on_card                :string(255)     not null
#  card_number                 :string(255)     not null
#  expiration_date             :date            
#  ccv                         :string(255)     not null
#  created_on                  :date            
#  billing_address_location_id :integer         
#

class CreditCard < ActiveRecord::Base
  belongs_to :person
  validates_length_of :card_type, :maximum => 250
  validates_length_of :name_on_card, :maximum => 250
  validates_length_of :card_number, :maximum => 250
  validates_length_of :ccv, :maximum => 250
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.card_type = String.new
      self.name_on_card = String.new
      self.card_number = String.new
      self.ccv = String.new
    end
  end
end
