class CreatePredictionComments < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_comments do |t|

      t.timestamps
      t.integer  "prediction_id"
      t.integer  "comment_id"
    end
  end
end
