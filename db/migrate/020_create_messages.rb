class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :sender, :integer
      t.column :person_id, :integer
      t.column :subject, :string
      t.column :body, :text
      t.column :state, :integer, :default => 0
      t.column :date_read, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
