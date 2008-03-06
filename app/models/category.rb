# == Schema Information
# Schema version: 28
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  name        :string(255)     not null
#  description :string(255)     not null
#

# Category is used to link types of locations, people, etc, without hard coding it into the program
class Category < ActiveRecord::Base
  has_many :sale_items
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.name = String.new if self.name.nil?
      self.description = self.description if self.description.nil?
    end
  end
  
end
