class AddLoginTokenToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :login_token, :string
  end

  def self.down
    remove_column :people, :login_token
  end
end
