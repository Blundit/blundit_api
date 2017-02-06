class CreateExperts < ActiveRecord::Migration[5.0]
  def change
    create_table :experts do |t|
      t.timestamps
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
    end
  end
end
