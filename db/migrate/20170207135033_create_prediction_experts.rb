class CreatePredictionExperts < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_experts do |t|

      t.timestamps
      t.integer "prediction_id"
      t.integer "expert_id"
    end
  end
end
