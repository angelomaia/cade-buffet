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

ActiveRecord::Schema[7.1].define(version: 2024_05_03_153659) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "buffets", force: :cascade do |t|
    t.string "name"
    t.string "corporate_name"
    t.string "cnpj"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "description"
    t.boolean "pix"
    t.boolean "debit"
    t.boolean "credit"
    t.boolean "cash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.index ["owner_id"], name: "index_buffets_on_owner_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "min_people"
    t.string "max_people"
    t.string "duration"
    t.string "menu"
    t.boolean "alcohol"
    t.boolean "decoration"
    t.boolean "parking"
    t.integer "location", default: 0
    t.integer "buffet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buffet_id"], name: "index_event_types_on_buffet_id"
  end

  create_table "order_prices", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "event_type_id", null: false
    t.integer "buffet_id", null: false
    t.decimal "base"
    t.decimal "discount"
    t.decimal "fee"
    t.decimal "total"
    t.string "payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.date "expiration_date"
    t.index ["buffet_id"], name: "index_order_prices_on_buffet_id"
    t.index ["event_type_id"], name: "index_order_prices_on_event_type_id"
    t.index ["order_id"], name: "index_order_prices_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "buffet_id", null: false
    t.integer "event_type_id", null: false
    t.integer "user_id", null: false
    t.date "date"
    t.integer "guest_quantity"
    t.string "details"
    t.string "code"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "location", default: 0
    t.index ["buffet_id"], name: "index_orders_on_buffet_id"
    t.index ["event_type_id"], name: "index_orders_on_event_type_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.float "base"
    t.float "extra_person"
    t.float "extra_hour"
    t.float "weekend_base"
    t.float "weekend_extra_person"
    t.float "weekend_extra_hour"
    t.integer "event_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type_id"], name: "index_prices_on_event_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "cpf"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buffets", "owners"
  add_foreign_key "event_types", "buffets"
  add_foreign_key "order_prices", "buffets"
  add_foreign_key "order_prices", "event_types"
  add_foreign_key "order_prices", "orders"
  add_foreign_key "orders", "buffets"
  add_foreign_key "orders", "event_types"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "event_types"
end
