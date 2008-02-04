# == Schema Information
# Schema version: 24
#
# Table name: destinations
#
#  id          :integer         not null, primary key
#  vacation_id :integer         
#  position    :integer         
#  location_id :integer         
#  notes       :text            
#  arrival     :datetime        
#  departure   :datetime        
#

class Destination < ActiveRecord::Base
  belongs_to :vacation
  acts_as_list :scope => :vacation
end
