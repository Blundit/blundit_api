class AddVoteValueToVoteOverride < ActiveRecord::Migration[5.0]
  def change
    add_column :vote_overrides, :vote_value, :integer
  end
end
