class BreakOutData < ActiveRecord::Migration
  def self.up
    remove_column :photos, :data
    add_column :photos, :data_id, :integer
    create_table :data do |t|
      t.column :data, :blob
    end
  end

  def self.down
    drop_table :data
  end
end
