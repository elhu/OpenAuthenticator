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

ActiveRecord::Schema.define(:version => 20110227192538) do

  create_table "account_tokens", :force => true do |t|
    t.string   "account_token"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_tokens", ["user_id"], :name => "index_account_tokens_on_user_id"

  create_table "personal_keys", :force => true do |t|
    t.string   "personal_key"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personal_keys", ["user_id"], :name => "index_personal_keys_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthdate"
    t.string   "email"
    t.string   "emergency_pass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "email_index", :unique => true
  add_index "users", ["login"], :name => "login_index", :unique => true

end
