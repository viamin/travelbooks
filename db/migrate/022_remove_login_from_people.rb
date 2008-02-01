class RemoveLoginFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :login
    remove_column :people, :title
    remove_column :people, :suffix
    remove_column :people, :birthday
    remove_column :people, :headline
    remove_column :people, :notes
    add_column :people, :privacy_flags, :integer, :default => 0
  end

  def self.down
    add_column :people, :login, :string
    add_column :people, :title, :string
    add_column :people, :suffix, :string
    add_column :people, :birthday, :date
    add_column :people, :headline, :string
    add_column :people, :notes, :text
    remove_column :people, :privacy_flags
  end
end
