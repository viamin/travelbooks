# == Schema Information
# Schema version: 10
#
# Table name: locations
#
#  id             :integer       default(0), not null, primary key
#  description    :string(255)   default()
#  type           :string(255)   default()
#  person_id      :integer       default(0)
#  item_id        :integer       default(0)
#  address_line_1 :string(255)   default()
#  address_line_2 :string(255)   default()
#  city           :string(255)   default()
#  state          :string(255)   default()
#  zip_code       :string(255)   default()
#  country        :string(255)   default()
#  latitude       :string(255)   default()
#  longitude      :string(255)   default()
#  altitude_feet  :integer       default(0)
#

class Location < ActiveRecord::Base
  belongs_to :item
  belongs_to :person
  validates_presence_of :country
end
