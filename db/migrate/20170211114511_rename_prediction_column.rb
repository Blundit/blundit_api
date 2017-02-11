class RenamePredictionColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :predictions, :pass_date, :prediction_date
  end
end
