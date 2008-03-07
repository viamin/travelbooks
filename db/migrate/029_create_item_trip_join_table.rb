class CreateItemTripJoinTable < ActiveRecord::Migration
  def self.up
    create_table :items_trips, :id => false do |t|
        t.column :item_id, :integer
        t.column :trip_id, :integer
    end
  end

  def self.down
    drop_table :items_trips
    
  end
end
