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

ActiveRecord::Schema.define(version: 20170211215513) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "claim_id"
    t.integer  "prediction_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "claim_id"
    t.integer  "expert_id"
    t.integer  "prediction_id"
  end

  create_table "claim_categories", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "claim_id"
    t.integer  "category_id"
    t.integer  "user_id"
  end

  create_table "claim_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "claim_id"
  end

  create_table "claim_evidences", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "claim_id"
    t.integer  "evidence_id"
  end

  create_table "claim_experts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "claim_id"
    t.integer  "user_id"
    t.integer  "expert_id"
  end

  create_table "claim_flags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "claim_id"
    t.integer  "flag_id"
  end

  create_table "claim_votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "claim_id"
    t.integer  "vote_id"
  end

  create_table "claims", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "alias"
    t.integer  "status",      default: 0
    t.integer  "vote_count",  default: 0
    t.float    "vote_value"
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
  end

  create_table "contributions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.text     "description"
    t.integer  "expert_id"
    t.integer  "claim_id"
    t.integer  "evidence_id"
    t.integer  "comment_id"
    t.integer  "flag_id"
    t.integer  "prediction_id"
    t.text     "payload"
  end

  create_table "evidences", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.string   "image"
    t.text     "hash"
  end

  create_table "expert_categories", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "expert_id"
    t.integer  "category_id"
  end

  create_table "expert_claims", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "expert_id"
    t.integer  "claim_id"
  end

  create_table "expert_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "expert_id"
    t.integer  "comment_id"
  end

  create_table "expert_evidences", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "expert_id"
    t.integer  "evidence_id"
  end

  create_table "expert_flags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "expert_id"
    t.integer  "flag_id"
  end

  create_table "expert_predictions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "expert_id"
    t.integer  "prediction_id"
  end

  create_table "experts", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name"
    t.text     "description"
    t.string   "email"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "youtube"
    t.float    "accuracy"
    t.integer  "user_id"
    t.datetime "happened"
    t.integer  "expert_category_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "alias"
  end

  create_table "flags", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.text     "description"
    t.text     "url"
  end

  create_table "prediction_categories", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "category_id"
  end

  create_table "prediction_comments", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "comment_id"
  end

  create_table "prediction_evidences", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "evidence_id"
  end

  create_table "prediction_experts", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "expert_id"
  end

  create_table "prediction_flags", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "flag_id"
  end

  create_table "prediction_votes", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "prediction_id"
    t.integer  "vote_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title"
    t.text     "description"
    t.integer  "status",          default: 0
    t.integer  "vote_count"
    t.float    "vote_value"
    t.string   "alias"
    t.datetime "prediction_date"
  end

  create_table "publications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_claims", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "claim_id"
  end

  create_table "user_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "comment_id"
  end

  create_table "user_contributions", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.integer  "contribution_id"
  end

  create_table "user_experts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "expert_id"
  end

  create_table "user_flags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "flag_id"
  end

  create_table "user_predictions", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.integer  "prediction_id"
  end

  create_table "user_votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "vote_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "comments_count",         default: 0
    t.integer  "experts_added",          default: 0
    t.integer  "predictions_added",      default: 0
    t.integer  "claims_added",           default: 0
    t.integer  "votes_count",            default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "vote"
  end

end
