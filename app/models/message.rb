# == Schema Information
# Schema version: 20090214004612
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
  validates_length_of :subject, :maximum => 250
  
  attr_accessor :recipients
  
  # States keep track of who has done what with it - using powers of 2
  # for bitwise operations
  UNREAD = 0
  READ = 1
  REPLIED = 2
  DELETEDBYRECIPIENT = 4
  DELETEDBYSENDER = 8
  FRIENDSHIPREJECTED = 16
  
  # Message Types
  NORMAL = 0
  FRIENDREQUEST = 1
  INVITATION = 2
  BULLETIN = 3
  
  def is_read?
    return (self.state | Message::READ) == self.state
  end
  
  def is_replied?
    return (self.state | Message::REPLIED) == self.state
  end
  
  def is_rejected?
    return (self.state | Message::FRIENDSHIPREJECTED) == self.state
  end
  
  def is_friend_request?
    return self.message_type == Message::FRIENDREQUEST
  end
  
  def mark_replied!
    self.state = self.state - Message::REPLIED if self.is_replied?
    self.save!
  end
  
  def unreject
    self.state = self.state - Message::FRIENDSHIPREJECTED if self.is_rejected?
    self.save!
  end
  
  def state_string
    state_array = %w{ Unread }
    if self.is_read?
      state_array.delete "Unread"
    end
    if self.is_replied?
      state_array << "Replied"
    end
    return state_array.join(", ")
  end
  
  def admin_state_string
    state_array = %w{ Unread }
    if self.is_read?
      state_array.delete "Unread"
    end
    if self.is_replied?
      state_array << "Replied"
    end
    if self.is_deleted_by_sender?
      state_array << "Deleted by Sender"
    end
    if self.is_deleted_by_recipient?
      state_array << "Deleted by Recipient"
    end
    return state_array.join(", ")
  end
  
  def delete_by(deleter_id)
    if self.sender == deleter_id
      if (self.state | Message::DELETEDBYRECIPIENT) == Message::DELETEDBYRECIPIENT
        # Then both sender and recipient have deleted it
        self.delete
      else
        self.state = self.state | Message::DELETEDBYSENDER
        self.state = self.state | Message::READ
        self.save
      end
    elsif self.person_id == deleter_id
      if (self.state | Message::DELETEDBYSENDER) == Message::DELETEDBYSENDER
        self.delete
      else
        self.state = self.state | Message::DELETEDBYRECIPIENT
        self.state = self.state | Message::READ
        self.save
      end
    end
  end
  
  def is_deleted_by_recipient?
    return (self.state | Message::DELETEDBYRECIPIENT) == self.state
  end
  
  def is_deleted_by_sender?
    return (self.state | Message::DELETEDBYSENDER) == self.state
  end
  
  def undelete!
    self.state = self.state - Message::DELETEDBYRECIPIENT if self.is_deleted_by_recipient?
    self.unreject
    self.mark_unread
    self.save
  end
  
  def sender_p
    Person.find(self.sender)
  end
  
  def recipient_p
    Person.find(self.person_id)
  end
  
  def mark_read(time_read = Time.now)
#    timing self.state
    self.state = self.state | Message::READ
#    timing self.state
    self.date_read = time_read
    self.save!
  end
  
  def mark_unread
    self.date_read = nil
    self.state = self.state - Message::READ if self.is_read?
    self.save!
  end
  
  # Adds the new user as a friend of the message sender and vice versa
  def complete_invitation!(inv_recipient)
    self.sender_p.add_friend(inv_recipient.id)
    self.mark_read
  end
  
  def self.send_request(from_person, to_person)
    message = Message.new
    message.sender = from_person.id
    message.person_id = to_person.id
    message.message_type = Message::FRIENDREQUEST
    message.subject = "#{from_person.display_name} would like to add you as a friend"
    message.save
    message
  end
  
  def self.check_for_request(from_person, to_person)
    messages = Message.find(:all, :conditions => {:sender => from_person.id, :person_id => to_person.id, :message_type => Message::FRIENDREQUEST})
    return !messages.empty?
  end
  
  def accept_friendship(acceptance)
    if self.message_type == Message::FRIENDREQUEST && acceptance == "Accept"
      self.sender_p.add_friend(self.person_id)
      self.destroy
      friend_added = true
    else # friendship was not accepted
      self.state = self.state | Message::FRIENDSHIPREJECTED
      self.save!
      self.delete_by(self.person_id)
      friend_added = false
    end
    return friend_added
  end
  
  # Adds '>' characters in front of a reply
  def reply_body(reply_to, sent_at)
    # replace the line below with the body with '>' characters
    body = self.body
    "\n\n\n-----------------------\n#{reply_to} on #{sent_at} wrote:\n#{body}"
  end
  
  def parse_recipients
    self.recipients.scan(/(\w.+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i).unique
  end
  
end
