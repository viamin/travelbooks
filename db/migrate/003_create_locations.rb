class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :description, :string, :length => 180
      t.column :type, :string, :length => 40
      t.column :person_id, :integer
      t.column :item_id, :integer
      t.column :address_line_1, :string, :length => 60
      t.column :address_line_2, :string, :length => 60
      t.column :city, :string, :length => 60
      t.column :state, :string, :length => 30
      t.column :zip_code, :string, :length => 20
      t.column :country, :string, :length => 60
      t.column :latitude, :string, :length => 60
      t.column :longitude, :string, :length => 60
      t.column :altitude_feet, :integer
    end
  end
  
  def self.down
    drop_table :locations

  end
end
