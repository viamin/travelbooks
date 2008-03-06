class AddDatesToSaleItems < ActiveRecord::Migration
  def self.up
    add_column :sale_items, :created_on, :date
    add_column :sale_items, :updated_on, :date
    add_column :sale_items, :sale_ends, :date
    add_column :sale_items, :sale_begins, :date
    add_column :orders, :status, :integer
  end

  def self.down
    remove_column :sale_items, :created_on
    remove_column :sale_items, :updated_on
    remove_column :sale_items, :sale_ends
    remove_column :sale_items, :sale_begins
    remove_column :orders, :status
  end
end
