class CreateSaleItems < ActiveRecord::Migration
  def self.up
    create_table :sale_items do |t|
        t.column :name, :string, :length => 60
        t.column :description, :string, :length => 255
        t.column :quantity_in_stock, :integer
        t.column :price, :float
        t.column :for_sale, :string, :length => 100
        t.column :sale_price, :float
        t.column :status, :integer
        t.column :category_id, :integer
    end
  end

  def self.down
    drop_table :sale_items
    
  end
end
