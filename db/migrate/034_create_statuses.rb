class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column :person_id, :integer
      t.column :item_id, :integer
      t.column :status, :string
      t.integer :status_type
      t.timestamps
    end
    add_column :locations, :status_id, :integer
  end

  def self.down
    drop_table :statuses
    remove_column :locations, :status_id
  end
end
