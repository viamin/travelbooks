# == Schema Information
# Schema version: 28
#
# Table name: data
#
#  id   :integer         not null, primary key
#  data :binary          
#

class Datum < ActiveRecord::Base
  belongs_to :photo
end
