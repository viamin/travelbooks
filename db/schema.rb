# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090214004612) do

  create_table "categories", :force => true do |t|
    t.string "name",        :null => false
    t.string "description", :null => false
  end

  create_table "changes", :force => true do |t|
    t.integer "change_type"
    t.integer "item_id"
    t.integer "person_id"
    t.integer "location_id"
    t.string  "old_value"
    t.string  "new_value",      :null => false
    t.date    "effective_date"
    t.date    "created_on"
  end

  create_table "credit_cards", :force => true do |t|
    t.integer "person_id"
    t.string  "card_type",                   :null => false
    t.string  "name_on_card",                :null => false
    t.string  "card_number",                 :null => false
    t.date    "expiration_date"
    t.string  "ccv",                         :null => false
    t.date    "created_on"
    t.integer "billing_address_location_id"
  end

  create_table "data", :force => true do |t|
    t.binary  "data"
    t.integer "photo_id"
  end

  create_table "destinations", :force => true do |t|
    t.integer  "trip_id"
    t.string   "name"
    t.integer  "position"
    t.integer  "location_id"
    t.text     "notes"
    t.datetime "arrival"
    t.datetime "departure"
    t.integer  "change_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "friends", :force => true do |t|
    t.integer "owner_person_id"
    t.integer "entry_person_id"
    t.integer "permissions"
  end

  create_table "items", :force => true do |t|
    t.string  "tbid"
    t.string  "name",        :null => false
    t.text    "description", :null => false
    t.integer "person_id"
    t.date    "created_on"
  end

  create_table "items_trips", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "trip_id"
  end

  create_table "line_items", :force => true do |t|
    t.integer "shopping_cart_id"
    t.integer "order_id"
    t.integer "sale_item_id"
    t.integer "quantity"
    t.float   "price_per_item"
    t.date    "created_on"
  end

  create_table "locations", :force => true do |t|
    t.string   "description",                   :null => false
    t.integer  "loc_type",       :default => 1
    t.integer  "person_id"
    t.integer  "item_id"
    t.string   "address_line_1",                :null => false
    t.string   "address_line_2"
    t.string   "city",                          :null => false
    t.string   "state",                         :null => false
    t.string   "zip_code",                      :null => false
    t.string   "country",                       :null => false
    t.integer  "altitude_feet",  :default => 0
    t.datetime "date_start"
    t.datetime "date_end"
    t.boolean  "public"
    t.float    "lat"
    t.float    "lng"
    t.string   "icon"
    t.integer  "status_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender"
    t.integer  "person_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "state",        :default => 0
    t.datetime "date_read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_type", :default => 0
  end

  create_table "orders", :force => true do |t|
    t.integer "person_id"
    t.integer "shipping_location_id"
    t.date    "created_on"
    t.date    "shipped_on"
    t.date    "paid_on"
    t.integer "status"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name",                          :null => false
    t.string   "middle_name"
    t.string   "last_name",                           :null => false
    t.string   "email",                               :null => false
    t.text     "hashed_password"
    t.date     "created_on"
    t.string   "nickname"
    t.string   "salt"
    t.integer  "privacy_flags",    :default => 0
    t.boolean  "needs_reset"
    t.string   "login_token"
    t.boolean  "private_profile",  :default => false
    t.datetime "last_login"
    t.integer  "mail_preferences"
  end

  create_table "photos", :force => true do |t|
    t.string  "path",         :null => false
    t.string  "file_name",    :null => false
    t.string  "url",          :null => false
    t.string  "content_type", :null => false
    t.integer "bytes"
    t.integer "width"
    t.integer "height"
    t.string  "caption",      :null => false
    t.integer "photo_type"
    t.integer "location_id"
    t.integer "person_id"
    t.integer "item_id"
    t.date    "created_on"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "person_id"
    t.integer  "review_type"
    t.integer  "reviewee_id"
    t.integer  "rating"
    t.text     "comments"
    t.integer  "flags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_items", :force => true do |t|
    t.string  "name",                               :null => false
    t.string  "description",                        :null => false
    t.integer "quantity_in_stock", :default => 0
    t.float   "price",             :default => 0.0
    t.string  "for_sale",                           :null => false
    t.float   "sale_price",        :default => 0.0
    t.integer "status"
    t.integer "category_id"
    t.date    "created_on"
    t.date    "updated_on"
    t.date    "sale_ends"
    t.date    "sale_begins"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shopping_carts", :force => true do |t|
    t.integer "person_id"
    t.date    "created_on"
    t.date    "modified_on"
    t.date    "last_viewed"
  end

  create_table "statistics", :force => true do |t|
    t.integer "person_id"
    t.integer "item_id"
    t.integer "location_id"
    t.integer "stat_type"
    t.string  "key"
    t.string  "value"
    t.string  "related_stats"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "person_id"
    t.integer  "item_id"
    t.string   "status"
    t.integer  "status_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", :force => true do |t|
    t.string  "name"
    t.integer "person_id"
    t.date    "start_date"
    t.date    "end_date"
    t.string  "companions"
    t.integer "item_id"
  end

end
