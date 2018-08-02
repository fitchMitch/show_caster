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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180721141902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.integer  "stage_role"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_actors_on_event_id", using: :btree
    t.index ["user_id"], name: "index_actors_on_user_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.string   "answer_label"
    t.datetime "date_answer"
    t.integer  "poll_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["poll_id"], name: "index_answers_on_poll_id", using: :btree
  end

  create_table "coaches", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "cell_phone_nr"
    t.string   "note"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "event_date"
    t.integer  "duration"
    t.integer  "progress",        default: 0
    t.text     "note"
    t.integer  "user_id"
    t.integer  "theater_id"
    t.string   "fk"
    t.string   "provider"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "title"
    t.string   "type",            default: "Performance"
    t.integer  "courseable_id"
    t.string   "courseable_type"
    t.index ["courseable_type", "courseable_id"], name: "index_events_on_courseable_type_and_courseable_id", using: :btree
    t.index ["theater_id"], name: "index_events_on_theater_id", using: :btree
    t.index ["type"], name: "index_events_on_type", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "fk"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "note"
    t.string   "descro"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "polls", force: :cascade do |t|
    t.string   "question"
    t.date     "expiration_date"
    t.string   "type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "owner_id"
    t.index ["owner_id"], name: "index_polls_on_owner_id", using: :btree
  end

  create_table "theaters", force: :cascade do |t|
    t.string "theater_name",  null: false
    t.string "location"
    t.string "manager"
    t.string "manager_phone"
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",                   null: false
    t.string   "lastname",                    null: false
    t.string   "email"
    t.datetime "last_sign_in_at"
    t.integer  "status",          default: 0
    t.string   "provider"
    t.string   "uid"
    t.string   "address"
    t.string   "cell_phone_nr"
    t.string   "photo_url"
    t.integer  "role",            default: 0
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "color"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["uid"], name: "index_users_on_uid", using: :btree
  end

  add_foreign_key "actors", "events"
  add_foreign_key "actors", "users"
  add_foreign_key "answers", "polls"
  add_foreign_key "events", "theaters"
  add_foreign_key "events", "users"
end
