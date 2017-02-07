class CreateExpertClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_claims do |t|

      t.timestamps
      t.integer "expert_id"
      t.integer "claim_id"
    end
  end
end