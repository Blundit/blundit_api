class CreateClaimEvidences < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_evidences do |t|

      t.timestamps
      t.integer "claim_id"
      t.integer "evidence_id"
    end
  end
end
