class CreatePredictionVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_votes do |t|

      t.timestamps
      t.integer "prediction_id"
      t.integer "vote_id"
    end
  end
end
