# == Schema Information
# Schema version: 13
#
# Table name: photos
#
#  id           :integer       not null, primary key
#  path         :string(255)   default(NULL)
#  file_name    :string(255)   default(NULL)
#  url          :string(255)   default(NULL)
#  data         :binary        default(NULL)
#  content_type :string(255)   default(NULL)
#  bytes        :integer       default(0)
#  width        :integer       default(0)
#  height       :integer       default(0)
#  caption      :string(255)   default(NULL)
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
