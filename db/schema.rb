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

ActiveRecord::Schema.define(:version => 20110818234130) do

  create_table "ac_registrations", :force => true do |t|
    t.integer  "accelerator_id"
    t.integer  "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accelerator_users", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accelerator_users", ["email"], :name => "index_accelerator_users_on_email", :unique => true
  add_index "accelerator_users", ["name"], :name => "index_accelerator_users_on_name", :unique => true

  create_table "accelerators", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "season"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "website"
    t.date     "duedate"
    t.date     "startdate"
    t.integer  "length"
    t.text     "description"
    t.string   "acceptlate"
    t.string   "acceptapp"
    t.string   "acceptemail"
    t.string   "izzaproved"
    t.integer  "accelerator_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qfounders", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "role"
    t.integer  "willcode"
    t.string   "weblink"
    t.integer  "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questionnaires", :force => true do |t|
    t.string   "companyname"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "website"
    t.string   "webvideo"
    t.text     "description"
    t.text     "team"
    t.text     "businessplan"
    t.text     "competition"
    t.text     "other"
    t.text     "invest"
    t.text     "advisor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
