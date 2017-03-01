class ChangeEvidenceOfBeliefColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :evidence_of_beliefs, :prediction_id, :expert_prediction_id
    rename_column :evidence_of_beliefs, :claim_id, :expert_claim_id
  end
end
