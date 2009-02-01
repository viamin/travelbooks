class AddPrivateProfileToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :private_profile, :boolean, :default => false
  end

  def self.down
    remove_column :people, :private_profile
  end
end
