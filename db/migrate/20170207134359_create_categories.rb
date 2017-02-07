class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|

      t.timestamps
      t.string   "name"
      t.text     "description"
      t.integer  "user_id"
      t.integer  "claim_id"
      t.integer  "expert_id"
      t.integer  "prediction_id"
    end
  end
end
