class RenameAddressBookItemsToFriends < ActiveRecord::Migration
  def self.up
    rename_table :address_book_items, :friends
  end

  def self.down
    rename_table :friends, :address_book_items
  end
end
