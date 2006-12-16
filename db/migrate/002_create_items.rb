class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
        t.column :name, :string, :length => 180
        t.column :description, :text
        t.column :person_id, :integer
        t.column :created_on, :date
    end
  end

  def self.down
    drop_table :items
    
  end
end
