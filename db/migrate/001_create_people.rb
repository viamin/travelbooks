class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :title, :string, :length => 10
      t.column :first_name, :string, :length => 40, :null => false
      t.column :middle_name, :string, :length => 40
      t.column :last_name, :string, :length => 50, :null => false
      t.column :suffix, :string, :length => 15
      t.column :birthday, :date, :null => false
      t.column :email, :string, :length => 40, :null => false
      t.column :login, :string, :length => 20, :null => false
      t.column :hashed_password, :text
      t.column :created_on, :date
      t.column :notes, :text, :null => false
    end
    
  end

  def self.down
    drop_table :people
  end
end
