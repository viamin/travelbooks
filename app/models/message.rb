# == Schema Information
# Schema version: 20
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  sender     :integer         
#  person_id  :integer         
#  subject    :string(255)     
#  body       :text            
#  state      :integer         default(0)
#  date_read  :datetime        
#  created_at :datetime        
#  updated_at :datetime        
#

class Message < ActiveRecord::Base
  belongs_to :person
  
  # States keep track of who has done what with it - using powers of 2
  # for bitwise operations
  READ = 1
  DELETEDBYRECIPIENT = 4
  DELETEDBYSENDER = 2
  
  def delete_by(deleter_id)
    if self.sender == deleter_id
      if (self.state & Message::DELETEDBYRECIPIENT) == Message::DELETEDBYRECIPIENT
        # Then both sender and recipient have deleted it
        self.delete
      else
        self.state = self.state | Message::DELETEDBYSENDER
        self.save
      end
    elsif self.person_id == deleter_id
      if (self.state & Message::DELETEDBYSENDER) == Message::DELETEDBYSENDER
        self.delete
      else
        self.state = self.state | Message::DELETEDBYRECIPIENT
        self.save
      end
    end
  end
  
  def sender_p
    Person.find(self.sender)
  end
  
  def mark_read(time_read = Time.now)
    self.state = self.state | Message::READ
    self.date_read = time_read
    self.save!
  end
  
  def mark_unread
    self.date_read = nil
    self.state = self.state - Message::READ unless (self.state | Message::READ) == Message::READ
    self.save!
  end
  
end
