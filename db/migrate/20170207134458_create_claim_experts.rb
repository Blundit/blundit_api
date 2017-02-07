class CreateClaimExperts < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_experts do |t|
      t.timestamps
      t.integer  "claim_id"
      t.integer  "user_id"
      t.integer  "expert_id"
    end
  end
end
