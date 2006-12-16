class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
        t.column :person_id, :integer
        t.column :shipping_location_id, :integer
        t.column :created_on, :date
        t.column :shipped_on, :date
        t.column :paid_on, :date
    end
  end

  def self.down
    drop_table :orders
    
  end
end
