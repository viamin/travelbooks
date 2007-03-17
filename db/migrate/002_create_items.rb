class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
        t.column :tbid, :string
        t.column :name, :string, :length => 180, :null => false
        t.column :description, :text, :null => false
        t.column :person_id, :integer
        t.column :created_on, :date
    end
  end

  def self.down
    drop_table :items
    
  end
end
