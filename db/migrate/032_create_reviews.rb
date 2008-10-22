class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
        t.integer :person_id
        t.integer :review_type
        t.integer :reviewee_id
        t.integer :rating
        t.text :comments
        t.integer :flags
        t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
