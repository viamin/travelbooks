class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.column :vacation_id, :integer
      t.column :position, :integer
      t.column :location_id, :integer
      t.column :notes, :text
      t.column :arrival, :datetime
      t.column :departure, :datetime
    end
  end

  def self.down
    drop_table :destinations
  end
end
