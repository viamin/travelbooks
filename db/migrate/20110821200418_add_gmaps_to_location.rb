class AddGmapsToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :gmaps, :boolean
  end

  def self.down
    remove_column :locations, :column_name
  end
end