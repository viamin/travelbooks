class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
        t.column :name, :string, :length => 60
        t.column :description, :string, :length => 255
    end
  end

  def self.down
    drop_table :categories
    
  end
end
