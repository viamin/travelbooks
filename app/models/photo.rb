# == Schema Information
# Schema version: 14
#
# Table name: photos
#
#  id           :integer       not null, primary key
#  path         :string(255)   not null
#  file_name    :string(255)   not null
#  url          :string(255)   not null
#  data         :binary        default(NULL)
#  content_type :string(255)   not null
#  bytes        :integer       default(0)
#  width        :integer       default(0)
#  height       :integer       default(0)
#  caption      :string(255)   not null
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
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.path = String.new
      self.file_name = String.new
      self.url = String.new
      self.content_type = String.new
      self.caption = String.new
    end
  end
  
end
