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

ActiveRecord::Schema.define(version: 20170322200815) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "bona_fides", force: :cascade do |t|
    t.integer "expert_id"
    t.string  "url"
    t.text    "description"
    t.string  "title"
    t.string  "bona_fide_type"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "claim_id"
    t.integer  "prediction_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "notify",        default: true
    t.boolean  "has_update",    default: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "description"
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
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "alias"
    t.integer  "status",               default: 0
    t.integer  "claim_votes_count",    default: 0
    t.float    "vote_value"
    t.integer  "claim_comments_count", default: 0
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.boolean  "visibility",        default: true
    t.string   "reason_for_hiding"
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
    t.integer  "bona_fide_id"
    t.integer  "bonafide_id"
  end

  create_table "evidence_of_beliefs", force: :cascade do |t|
    t.integer  "expert_id"
    t.integer  "expert_prediction_id"
    t.integer  "expert_claim_id"
    t.string   "domain"
    t.text     "description"
    t.string   "title"
    t.string   "pic"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "url"
    t.text     "url_content"
  end

  create_table "evidences", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.string   "image"
    t.text     "url_content"
    t.string   "domain"
  end

  create_table "expert_categories", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "expert_id"
    t.integer  "category_id"
    t.boolean  "source",      default: false
  end

  create_table "expert_category_accuracies", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "expert_id"
    t.float    "claim_accuracy"
    t.integer  "correct_claims",        default: 0
    t.integer  "incorrect_claims",      default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.float    "prediction_accuracy"
    t.float    "overall_accuracy"
    t.integer  "incorrect_predictions"
    t.integer  "correct_predictions"
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
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
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
    t.float    "prediction_accuracy"
    t.float    "claim_accuracy"
    t.integer  "expert_comments_count", default: 0
  end

  create_table "flags", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.text     "description"
    t.text     "url"
  end

  create_table "notification_queue_items", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "item_type"
    t.integer  "claim_id"
    t.integer  "prediction_id"
    t.integer  "expert_id"
    t.string   "message"
    t.integer  "comment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "category_id"
  end

  create_table "notification_queues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "title"
    t.text     "description"
    t.integer  "status",                    default: 0
    t.integer  "prediction_votes_count",    default: 0
    t.float    "vote_value"
    t.string   "alias"
    t.datetime "prediction_date"
    t.integer  "prediction_comments_count", default: 0
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
  end

  create_table "publications", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "domain"
    t.text     "description"
    t.string   "title"
    t.string   "pic"
    t.integer  "correct_predictions"
    t.integer  "correct_claims"
    t.integer  "incorrect_predictions"
    t.integer  "incorrect_claims"
    t.float    "prediction_accuracy"
    t.float    "claim_accuracy"
    t.integer  "claims_count"
    t.integer  "predictions_count"
  end

  create_table "searches", force: :cascade do |t|
    t.string   "user_id"
    t.string   "integer"
    t.string   "query"
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "comments_count",         default: 0
    t.integer  "experts_added",          default: 0
    t.integer  "predictions_added",      default: 0
    t.integer  "claims_added",           default: 0
    t.integer  "votes_count",            default: 0
    t.integer  "notification_frequency", default: 1
    t.integer  "user_comments_count",    default: 0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "nickname"
    t.text     "tokens"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "vote"
  end

end
