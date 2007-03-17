class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :description, :string, :length => 180, :null => false
      t.column :loc_type, :integer, :default => 1
      t.column :person_id, :integer
      t.column :item_id, :integer
      t.column :credit_card_id, :integer, :default => 0
      t.column :address_line_1, :string, :length => 60, :null => false
      t.column :address_line_2, :string, :length => 60
      t.column :city, :string, :length => 60, :null => false
      t.column :state, :string, :length => 30, :null => false
      t.column :zip_code, :string, :length => 20, :null => false
      t.column :country, :string, :length => 60, :null => false
      t.column :latitude, :string, :length => 60, :null => false
      t.column :longitude, :string, :length => 60, :null => false
      t.column :altitude_feet, :integer, :default => 0
    end
  end
  
  def self.down
    drop_table :locations

  end
end
