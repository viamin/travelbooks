class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
        t.column :person_id, :integer
        t.column :card_type, :string, :length => 40
        t.column :billing_location_id, :integer
        t.column :name_on_card, :string, :length => 100
        t.column :card_number, :string, :length => 80
        t.column :expiration_date, :date
        t.column :ccv, :string, :length => 10
        t.column :created_on, :date
    end
  end

  def self.down
    drop_table :credit_cards
    
  end
end
