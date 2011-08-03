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

ActiveRecord::Schema.define(:version => 20110803055908) do

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
    t.date     "enddate"
    t.integer  "length"
    t.text     "description", :limit => 255
    t.string   "acceptlate"
    t.string   "acceptapp"
    t.string   "acceptemail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "equity"
    t.string   "offer"
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
    t.text     "description",  :limit => 255
    t.text     "team",         :limit => 255
    t.text     "businessplan", :limit => 255
    t.text     "competition",  :limit => 255
    t.text     "other",        :limit => 255
    t.text     "invest",       :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "advisor",      :limit => 255
  end

  create_table "registrations", :force => true do |t|
    t.integer  "accelerator_id"
    t.integer  "questionnaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
