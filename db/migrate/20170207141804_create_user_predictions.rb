class CreateUserPredictions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_predictions do |t|

      t.timestamps
      t.integer "user_id"
      t.integer "prediction_id"
    end
  end
end
