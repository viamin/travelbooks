class CreateAddressBookItems < ActiveRecord::Migration
  def self.up
    create_table :address_book_items do |t|
      t.column :owner_person_id, :integer
      t.column :entry_person_id, :integer
      t.column :permissions, :integer
    end
  end

  def self.down
    drop_table :address_book_items
  end
end
