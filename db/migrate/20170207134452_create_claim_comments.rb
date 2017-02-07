class CreateClaimComments < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_comments do |t|
      t.timestamps
      t.integer  "user_id"
      t.integer  "comment_id"
    end
  end
end
