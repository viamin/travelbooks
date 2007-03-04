# == Schema Information
# Schema version: 11
#
# Table name: categories
#
#  id          :integer       not null, primary key
#  name        :string(255)   default(NULL)
#  description :string(255)   default(NULL)
#

class Category < ActiveRecord::Base
end
