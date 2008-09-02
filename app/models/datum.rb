# == Schema Information
# Schema version: 31
#
# Table name: data
#
#  id   :integer         not null, primary key
#  data :binary          
#

class Datum < ActiveRecord::Base
  belongs_to :photo
end
