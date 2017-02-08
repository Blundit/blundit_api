class CreateExpertPredictions < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_predictions do |t|

      t.timestamps
      t.integer "expert_id"
      t.integer "prediction_id"
    end
  end
end
