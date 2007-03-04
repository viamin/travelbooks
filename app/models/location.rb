# == Schema Information
# Schema version: 12
#
# Table name: locations
#
#  id             :integer       default(0), not null, primary key
#  description    :string(255)   default(NULL)
#  loc_type       :string(255)   default(NULL)
#  person_id      :integer       default(0)
#  item_id        :integer       default(0)
#  address_line_1 :string(255)   default(NULL)
#  address_line_2 :string(255)   default(NULL)
#  city           :string(255)   default(NULL)
#  state          :string(255)   default(NULL)
#  zip_code       :string(255)   default(NULL)
#  country        :string(255)   default(NULL)
#  latitude       :string(255)   default(NULL)
#  longitude      :string(255)   default(NULL)
#  altitude_feet  :integer       default(0)
#

class Location < ActiveRecord::Base
  belongs_to :item
  belongs_to :person
  belongs_to :credit_card
  validates_presence_of :country
  
  ADDRESS = 1
  GPS = 2
  
  attr_reader ADDRESS
  attr_reader GPS
  
end
