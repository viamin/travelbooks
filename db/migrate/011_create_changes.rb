class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.column :change_type, :integer
      t.column :item_id, :integer
      t.column :person_id, :integer
      t.column :location_id, :integer
      t.column :old_value, :string
      t.column :new_value, :string, :null => false
      t.column :effective_date, :date
      t.column :created_on, :date
    end
  end

  def self.down
    drop_table :changes
    
  end
end
