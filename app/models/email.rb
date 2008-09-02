# == Schema Information
# Schema version: 31
#
# Table name: emails
#
#  id                :integer         not null, primary key
#  from              :string(255)     
#  to                :string(255)     
#  last_send_attempt :integer         default(0)
#  mail              :text            
#  created_on        :datetime        
#

class Email < ActiveRecord::Base
end
