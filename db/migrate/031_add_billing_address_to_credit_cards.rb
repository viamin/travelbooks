class AddBillingAddressToCreditCards < ActiveRecord::Migration
  def self.up
    add_column :credit_cards, :billing_address_location_id, :integer
    remove_column :locations, :credit_card_id
  end

  def self.down
    remove_column :credit_cards, :billing_address_location_id
    add_column :locations, :credit_card_id, :integer
  end
end
