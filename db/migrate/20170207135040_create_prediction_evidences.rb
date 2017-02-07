class CreatePredictionEvidences < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_evidences do |t|

      t.timestamps
      t.integer "prediction_id"
      t.integer "evidence_id"
    end
  end
end
