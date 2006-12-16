# == Schema Information
# Schema version: 10
#
# Table name: credit_cards
#
#  id                  :integer       default(0), not null, primary key
#  person_id           :integer       default(0)
#  card_type           :string(255)   default()
#  billing_location_id :integer       default(0)
#  name_on_card        :string(255)   default()
#  card_number         :string(255)   default()
#  expiration_date     :date          
#  ccv                 :string(255)   default()
#  created_on          :date          
#

class CreditCard < ActiveRecord::Base
end
