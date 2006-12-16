class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
        t.column :shopping_cart_id, :integer
        t.column :order_id, :integer
        t.column :sale_item_id, :integer
        t.column :quantity, :integer
        t.column :price_per_item, :float
        t.column :created_on, :date
    end
  end

  def self.down
    drop_table :line_items
    
  end
end
