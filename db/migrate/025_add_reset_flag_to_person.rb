class AddResetFlagToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :needs_reset, :boolean
  end

  def self.down
    remove_column :people, :needs_reset
  end
end
