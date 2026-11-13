ActiveRecord::Schema[7.1].define(version: 2026_07_20_100500) do
  enable_extension "plpgsql"

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

  create_table "adoption_requests", force: :cascade do |t|
    t.bigint "adopter_id", null: false
    t.bigint "pet_id", null: false
    t.text "message"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adopter_id"], name: "index_adoption_requests_on_adopter_id"
    t.index ["pet_id", "adopter_id"], name: "index_unique_active_request_per_pet_and_adopter", unique: true, where: "((status)::text = ANY ((ARRAY['pending'::character varying, 'accepted'::character varying])::text[]))"
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
