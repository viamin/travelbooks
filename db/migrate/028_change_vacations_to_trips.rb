class ChangeVacationsToTrips < ActiveRecord::Migration
  def self.up
    rename_table :vacations, :trips
    rename_column :destinations, :vacation_id, :trip_id
    add_column :destinations, :change_id, :integer
    add_column :trips, :item_id, :integer
  end

  def self.down
    remove_column :trips, :item_id
    rename_table :trips, :vacations
    rename_column :destinations, :trip_id, :vacation_id
    remove_column :destinations, :change_id
  end
end
