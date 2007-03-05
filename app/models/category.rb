# == Schema Information
# Schema version: 13
#
# Table name: categories
#
#  id          :integer       not null, primary key
#  name        :string(255)   default(NULL)
#  description :string(255)   default(NULL)
#

# Category is used to link types of locations, people, etc, without hard coding it into the program
class Category < ActiveRecord::Base
end
