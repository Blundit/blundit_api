class MakeClaimPredictionStatusString < ActiveRecord::Migration[5.0]
  def change
    change_column :predictions, :status, :string
    change_column :claims, :status, :string
  end
end
