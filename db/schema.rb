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

ActiveRecord::Schema.define(version: 20181209115127) do

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

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
    t.index ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
    t.index ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
    t.index ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree
  end

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
    t.index ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree
  end

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree
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
    t.boolean  "private_event",   default: false
    t.index ["courseable_type", "courseable_id"], name: "index_events_on_courseable_type_and_courseable_id", using: :btree
    t.index ["theater_id"], name: "index_events_on_theater_id", using: :btree
    t.index ["type"], name: "index_events_on_type", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "exercices", force: :cascade do |t|
    t.string   "title",                    null: false
    t.text     "instructions",             null: false
    t.integer  "category",     default: 0
    t.integer  "energy_level", default: 1
    t.string   "promess"
    t.string   "focus"
    t.integer  "max_people",   default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "fk"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "polls", force: :cascade do |t|
    t.string   "question"
    t.datetime "expiration_date"
    t.string   "type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "owner_id"
    t.index ["owner_id"], name: "index_polls_on_owner_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "theaters", force: :cascade do |t|
    t.string "theater_name",  null: false
    t.string "location"
    t.string "manager"
    t.string "manager_phone"
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",                       null: false
    t.string   "lastname",                        null: false
    t.string   "email"
    t.datetime "last_sign_in_at"
    t.integer  "status",              default: 0
    t.string   "provider"
    t.string   "uid"
    t.string   "address"
    t.string   "cell_phone_nr"
    t.string   "photo_url"
    t.integer  "role",                default: 0
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "color"
    t.text     "bio"
    t.datetime "former_connexion_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["uid"], name: "index_users_on_uid", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "poll_id"
    t.integer  "answer_id"
    t.integer  "user_id"
    t.string   "type"
    t.integer  "vote_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_votes_on_answer_id", using: :btree
    t.index ["poll_id"], name: "index_votes_on_poll_id", using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
  end

  add_foreign_key "actors", "events"
  add_foreign_key "actors", "users"
  add_foreign_key "answers", "polls"
  add_foreign_key "events", "theaters"
  add_foreign_key "events", "users"
  add_foreign_key "polls", "users", column: "owner_id"
  add_foreign_key "votes", "answers"
  add_foreign_key "votes", "polls"
  add_foreign_key "votes", "users"
end
