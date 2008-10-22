# == Schema Information
# Schema version: 34
#
# Table name: reviews
#
#  id          :integer         not null, primary key
#  person_id   :integer
#  review_type :integer
#  reviewee_id :integer
#  rating      :integer
#  comments    :text
#  flags       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Review < ActiveRecord::Base
  belongs_to :person
  
  
  ########### FLAGS #############
  INAPPROPRIATE_FLAG = 2**0
  
  ########### TYPES #############
  LOCATION_REVIEW = 2**0
  ITEM_REVIEW = 2**1
  PERSON_REVIEW = 2**2
  COMMENT = 2**3
end
