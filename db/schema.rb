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

ActiveRecord::Schema.define(version: 20170515001016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: :cascade do |t|
    t.string   "name",             null: false
    t.text     "description",      null: false
    t.date     "deadline",         null: false
    t.integer  "max_participants", null: false
    t.string   "kind"
    t.integer  "min_bet",          null: false
    t.integer  "max_bet",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.index ["name", "deadline"], name: "index_bets_on_name_and_deadline", unique: true, using: :btree
    t.index ["user_id"], name: "index_bets_on_user_id", using: :btree
  end

  create_table "choices", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "bet_id"
    t.index ["bet_id"], name: "index_choices_on_bet_id", using: :btree
    t.index ["value", "bet_id"], name: "index_choices_on_value_and_bet_id", unique: true, using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "amount",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "choice_id"
    t.integer  "bet_id"
    t.index ["bet_id"], name: "index_participations_on_bet_id", using: :btree
    t.index ["choice_id"], name: "index_participations_on_choice_id", using: :btree
    t.index ["user_id", "bet_id"], name: "index_participations_on_user_id_and_bet_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "mail",            null: false
    t.string   "role",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.index ["mail"], name: "index_users_on_mail", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "bets", "users"
  add_foreign_key "choices", "bets"
  add_foreign_key "participations", "bets"
  add_foreign_key "participations", "choices"
  add_foreign_key "participations", "users"
end
