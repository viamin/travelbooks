# == Schema Information
# Schema version: 20090214004612
#
# Table name: data
#
#  id       :integer         not null, primary key
#  data     :binary
#  photo_id :integer
#

class Datum < ActiveRecord::Base
  belongs_to :photo
end
