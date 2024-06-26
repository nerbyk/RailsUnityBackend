# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_11_075133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  # These are the common tables
  create_table "entities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "farm_id", null: false
    t.string "guid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name", null: false
    t.integer "level", default: 1, null: false
    t.box "location", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id", "guid"], name: "index_entities_on_farm_id_and_guid", unique: true
    t.index ["farm_id"], name: "index_entities_on_farm_id"
    t.index ["location"], name: "index_entities_on_location", using: :gist
    t.index ["user_id"], name: "index_entities_on_user_id"
  end

  create_table "entity_receipts", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.integer "level", default: 1, null: false
    t.datetime "completed_at"
    t.index ["completed_at", "status"], name: "index_entity_receipts_on_completed_at_and_status"
    t.index ["entity_id"], name: "index_entity_receipts_on_entity_id"
  end

  create_table "farms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_farms_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "farm_id", null: false
    t.string "name", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_items_on_farm_id"
    t.index ["name", "farm_id"], name: "index_items_on_name_and_farm_id", unique: true
    t.index ["user_id"], name: "index_items_on_user_id"
    t.check_constraint "amount >= 0", name: "amount_non_negative"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "entities", "farms"
  add_foreign_key "entities", "users"
  add_foreign_key "entity_receipts", "entities"
  add_foreign_key "farms", "users"
  add_foreign_key "items", "farms"
  add_foreign_key "items", "users"
end
