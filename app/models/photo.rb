# == Schema Information
# Schema version: 12
#
# Table name: photos
#
#  id           :integer       default(0), not null, primary key
#  path         :string(255)   default()
#  file_name    :string(255)   default()
#  url          :string(255)   default()
#  data         :binary        default()
#  content_type :string(255)   default()
#  bytes        :integer       default(0)
#  width        :integer       default(0)
#  height       :integer       default(0)
#  caption      :string(255)   default()
#  photo_type   :integer       default(0)
#  location_id  :integer       default(0)
#  person_id    :integer       default(0)
#  item_id      :integer       default(0)
#  created_on   :date          
#

class Photo < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  belongs_to :location
end
