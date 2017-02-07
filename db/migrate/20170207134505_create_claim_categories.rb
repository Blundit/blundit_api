class CreateClaimCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_categories do |t|

      t.timestamps
      t.integer  "claim_id"
      t.integer  "category_id"
      t.integer  "user_id"
    end
  end
end
