class CreateShoppingCarts < ActiveRecord::Migration
  def self.up
    create_table :shopping_carts do |t|
        t.column :person_id, :integer
        t.column :created_on, :date
        t.column :modified_on, :date
        t.column :last_viewed, :date
    end
  end

  def self.down
    drop_table :shopping_carts
    
  end
end
