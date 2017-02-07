class CreateExpertComments < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_comments do |t|

      t.timestamps
      t.integer  "expert_id"
      t.integer   "comment_id"
    end
  end
end
