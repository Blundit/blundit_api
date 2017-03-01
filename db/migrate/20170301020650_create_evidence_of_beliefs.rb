class CreateEvidenceOfBeliefs < ActiveRecord::Migration[5.0]
  def change
    create_table :evidence_of_beliefs do |t|
      t.integer "expert_id"
      t.integer "prediction_id"
      t.integer "claim_id"
      t.string "domain"
      t.text "description"
      t.string "title"
      t.string "pic"

      t.timestamps
    end
  end
end
