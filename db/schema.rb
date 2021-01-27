# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_26_172917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "requests", force: :cascade do |t|
    t.bigint "requester_id"
    t.bigint "service_id"
    t.string "text"
    t.string "file"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["requester_id"], name: "index_requests_on_requester_id"
    t.index ["service_id"], name: "index_requests_on_service_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "request_id"
    t.string "text"
    t.string "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_responses_on_request_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "response_id"
    t.bigint "reviewer_id"
    t.string "text"
    t.integer "rate"
    t.string "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["response_id"], name: "index_reviews_on_response_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name"
    t.float "price"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_services_on_owner_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_skills_on_owner_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "request_id"
    t.float "service_price"
    t.float "net"
    t.float "commission"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_transactions_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.string "description"
    t.integer "role", default: 0
    t.integer "balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
