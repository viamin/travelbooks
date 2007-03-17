class CreateSaleItems < ActiveRecord::Migration
  def self.up
    create_table :sale_items do |t|
        t.column :name, :string, :length => 60, :null => false
        t.column :description, :string, :length => 255, :null => false
        t.column :quantity_in_stock, :integer, :default => 0
        t.column :price, :float, :default => 0.0
        t.column :for_sale, :string, :length => 100, :null => false
        t.column :sale_price, :float, :default => 0.0
        t.column :status, :integer
        t.column :category_id, :integer
    end
  end

  def self.down
    drop_table :sale_items
    
  end
end
