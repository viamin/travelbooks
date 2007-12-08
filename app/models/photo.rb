# == Schema Information
# Schema version: 14
#
# Table name: photos
#
#  id           :integer       not null, primary key
#  path         :string(255)   not null
#  file_name    :string(255)   not null
#  url          :string(255)   not null
#  data         :binary        
#  content_type :string(255)   not null
#  bytes        :integer       
#  width        :integer       
#  height       :integer       
#  caption      :string(255)   not null
#  photo_type   :integer       
#  location_id  :integer       
#  person_id    :integer       
#  item_id      :integer       
#  created_on   :date          
#

# photo_type should be able to indicate if the photo is the primary photo for the given item/person/location
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
  
  def is_primary?
    return (photo_type == 1)
  end
  
  def self.default
    temp = Photo.new
    temp.path = '/images/'
    temp.file_name = 'no_image.png'
    temp.width = 200
    temp.height = 200
    temp
  end
end
