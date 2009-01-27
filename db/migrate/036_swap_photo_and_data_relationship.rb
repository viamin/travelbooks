class SwapPhotoAndDataRelationship < ActiveRecord::Migration
  def self.up
    add_column :data, :photo_id, :integer
    remove_column :photos, :data_id
  end

  def self.down
    remove_column :data, :photo_id
    add_column :photos, :data_id, :integer
  end
end
