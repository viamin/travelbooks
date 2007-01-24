# == Schema Information
# Schema version: 12
#
# Table name: categories
#
#  id          :integer       default(0), not null, primary key
#  name        :string(255)   default()
#  description :string(255)   default()
#

class Category < ActiveRecord::Base
end
