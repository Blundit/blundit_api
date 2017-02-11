class CreateBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :bookmarks do |t|
      t.integer  "user_id"
      t.integer  "expert_id"
      t.integer  "claim_id"
      t.integer  "prediction_id"
      t.timestamps
    end
  end
end
