class CreateVacations < ActiveRecord::Migration
  def self.up
    create_table :vacations do |t|
      t.column :name, :string
      t.column :person_id, :integer
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :companions, :string
    end
  end

  def self.down
    drop_table :vacations
  end
end
