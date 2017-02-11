class AdjustVoteValue < ActiveRecord::Migration[5.0]
  def change
    change_column :predictions, :vote_value, :float, precision: 6
  end
end
