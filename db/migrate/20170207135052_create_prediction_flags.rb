class CreatePredictionFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_flags do |t|

      t.timestamps
      t.integer "prediction_id"
      t.integer "flag_id"
    end
  end
end
