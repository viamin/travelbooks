class AddNicknameToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :nickname, :string
    add_column :people, :headline, :string
  end

  def self.down
    remove_column :people, :nickname
    remove_column :people, :headline
  end
end
