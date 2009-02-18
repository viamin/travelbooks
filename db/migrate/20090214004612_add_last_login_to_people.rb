class AddLastLoginToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :last_login, :datetime
    add_column :people, :mail_preferences, :integer
  end

  def self.down
    remove_column :people, :mail_preferences
    remove_column :people, :last_login
  end
end
