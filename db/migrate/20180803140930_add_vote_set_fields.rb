class AddVoteSetFields < ActiveRecord::Migration[5.0]
  def change
    add_column :vote_sets, :claim_id, :integer
    add_column :vote_sets, :prediction_id, :integer
  end
end
