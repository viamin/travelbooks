class AddIconToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :icon, :string
  end

  def self.down
    remove_column :locations, :icon
  end
end
