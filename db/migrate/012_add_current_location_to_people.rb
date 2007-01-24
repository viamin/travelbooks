class AddCurrentLocationToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :location_id, :integer
  end

  def self.down
    remove_column :people, :location_id
  end
end
