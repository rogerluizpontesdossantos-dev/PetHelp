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

ActiveRecord::Schema[8.1].define(version: 2026_11_13_230204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "adoption_requests", force: :cascade do |t|
    t.bigint "adopter_id", null: false
    t.bigint "pet_id", null: false
    t.text "message"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adopter_id"], name: "index_adoption_requests_on_adopter_id"
    t.index ["pet_id", "adopter_id"], name: "index_unique_active_request_per_pet_and_adopter", unique: true, where: "((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('accepted'::character varying)::text]))"
    t.index ["pet_id"], name: "index_adoption_requests_on_pet_id"
    t.index ["status"], name: "index_adoption_requests_on_status"
  end

  create_table "adoption_terms", force: :cascade do |t|
    t.bigint "adoption_request_id", null: false
    t.text "content", null: false
    t.datetime "signed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adoption_request_id"], name: "index_adoption_terms_on_adoption_request_id", unique: true
  end

  create_table "follow_ups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pet_id", null: false
    t.string "milestone", null: false
    t.string "status", default: "pending", null: false
    t.date "due_date", null: false
    t.datetime "answered_at"
    t.integer "well_being_rating"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["due_date"], name: "index_follow_ups_on_due_date"
    t.index ["pet_id", "user_id", "milestone"], name: "index_follow_ups_uniqueness", unique: true
    t.index ["pet_id"], name: "index_follow_ups_on_pet_id"
    t.index ["status"], name: "index_follow_ups_on_status"
    t.index ["user_id"], name: "index_follow_ups_on_user_id"
  end

  create_table "pets", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.integer "species", default: 0, null: false
    t.integer "size", default: 0, null: false
    t.text "description"
    t.string "city", null: false
    t.string "state", null: false
    t.string "status", default: "available", null: false
    t.boolean "vaccination_status", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_pets_on_city"
    t.index ["owner_id"], name: "index_pets_on_owner_id"
    t.index ["species"], name: "index_pets_on_species"
    t.index ["status"], name: "index_pets_on_status"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "reviewer_id", null: false
    t.bigint "reviewee_id", null: false
    t.bigint "adoption_request_id", null: false
    t.integer "rating", null: false
    t.string "comment", limit: 500
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adoption_request_id", "reviewer_id"], name: "index_reviews_one_per_reviewer_per_request", unique: true
    t.index ["adoption_request_id"], name: "index_reviews_on_adoption_request_id"
    t.index ["reviewee_id"], name: "index_reviews_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "cpf", null: false
    t.string "phone", null: false
    t.string "password_digest", null: false
    t.decimal "reputation_score", precision: 3, scale: 2, default: "0.0", null: false
    t.integer "reviews_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adoption_requests", "pets"
  add_foreign_key "adoption_requests", "users", column: "adopter_id"
  add_foreign_key "adoption_terms", "adoption_requests"
  add_foreign_key "follow_ups", "pets"
  add_foreign_key "follow_ups", "users"
  add_foreign_key "pets", "users", column: "owner_id"
  add_foreign_key "reviews", "adoption_requests"
  add_foreign_key "reviews", "users", column: "reviewee_id"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
