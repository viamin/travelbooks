# == Schema Information
# Schema version: 22
#
# Table name: messages
#
#  id           :integer         not null, primary key
#  sender       :integer         
#  person_id    :integer         
#  subject      :string(255)     
#  body         :text            
#  state        :integer         default(0)
#  date_read    :datetime        
#  created_at   :datetime        
#  updated_at   :datetime        
#  message_type :integer         default(0)
#

class Message < ActiveRecord::Base
  belongs_to :person
  
  # States keep track of who has done what with it - using powers of 2
  # for bitwise operations
  UNREAD = 0
  READ = 1
  DELETEDBYRECIPIENT = 4
  DELETEDBYSENDER = 2
  FRIENDSHIPREJECTED = 8
  
  # Message Types
  NORMAL = 0
  FRIENDREQUEST = 1
  
  
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
  
  def recipient_p
    Person.find(self.person_id)
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
  
  def self.send_request(from_person, to_person)
    message = Message.new
    message.sender = from_person.id
    message.person_id = to_person.id
    message.message_type = Message::FRIENDREQUEST
    message.subject = "#{from_person.display_name} would like to add you as a friend"
    message.save
  end
  
  def self.check_for_request(from_person, to_person)
    messages = Message.find(:all, :conditions => {:sender => from_person.id, :person_id => to_person.id, :message_type => Message::FRIENDREQUEST})
    return !messages.empty?
  end
  
  def accept_friendship(acceptance)
    if self.message_type == Message::FRIENDREQUEST && acceptance == "Accept"
      self.sender_p.add_friend(self.person_id)
      self.delete
    else # friendship was not accepted
      self.state = self.state | Message::FRIENDSHIPREJECTED
      self.save!
      self.delete_by(self.person_id)
    end
  end
  
end
