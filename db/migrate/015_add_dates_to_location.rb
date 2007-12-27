class AddDatesToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :date_start, :datetime
    add_column :locations, :date_end, :datetime
    add_column :locations, :public, :boolean
  end

  def self.down
    remove_column :locations, :date_start
    remove_column :locations, :date_end
    remove_column :locations, :public
  end
end
