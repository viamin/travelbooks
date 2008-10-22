class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.column :person_id, :integer
      t.column :item_id, :integer
      t.column :location_id, :integer
      t.column :stat_type, :integer
      t.column :key, :string
      t.column :value, :string
      t.column :related_stats, :string
    end
  end

  def self.down
    drop_table :statistics
  end
end
