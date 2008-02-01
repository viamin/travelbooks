class AddMessageTypeToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :message_type, :integer, :default => 0
  end

  def self.down
    remove_column :messages, :message_type
  end
end
