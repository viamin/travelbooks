class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
        t.column :path, :string, :length => 255, :null => false
        t.column :file_name, :string, :length => 60, :null => false
        t.column :url, :string, :length => 255, :null => false
        t.column :data, :blob
        t.column :content_type, :string, :length => 100, :null => false
        t.column :bytes, :integer
        t.column :width, :integer
        t.column :height, :integer
        t.column :caption, :string, :length => 255, :null => false
        t.column :photo_type, :integer
        t.column :location_id, :integer
        t.column :person_id, :integer
        t.column :item_id, :integer
        t.column :created_on, :date
    end
  end

  def self.down
    drop_table :photos
    
  end
end
