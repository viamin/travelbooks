class UpdateLocationsGeoCols < ActiveRecord::Migration
  def self.up
    remove_column :locations, :latitude
    remove_column :locations, :longitude
    add_column :locations, :lat, :float
    add_column :locations, :lng, :float
  end

  def self.down
    add_column :locations, :latitude, :string
    add_column :locations, :longitude, :string
    remove_column :locations, :lat
    remove_column :locations, :lng
  end
end
