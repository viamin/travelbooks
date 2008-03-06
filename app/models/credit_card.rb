# == Schema Information
# Schema version: 28
#
# Table name: credit_cards
#
#  id              :integer         not null, primary key
#  person_id       :integer         
#  card_type       :string(255)     not null
#  name_on_card    :string(255)     not null
#  card_number     :string(255)     not null
#  expiration_date :date            
#  ccv             :string(255)     not null
#  created_on      :date            
#

class CreditCard < ActiveRecord::Base
  belongs_to :person
  has_one :location
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.card_type = String.new
      self.name_on_card = String.new
      self.card_number = String.new
      self.ccv = String.new
    end
  end
  
  def billing_address
    self.location
  end
  
  def billing_address=(value)
    self.location = value
  end
end
