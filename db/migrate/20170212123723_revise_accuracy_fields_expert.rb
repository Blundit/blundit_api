class ReviseAccuracyFieldsExpert < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, :prediction_accuracy, :float
    add_column :experts, :claim_accuracy, :float
  end
end
