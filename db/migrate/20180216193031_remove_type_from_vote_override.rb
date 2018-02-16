class RemoveTypeFromVoteOverride < ActiveRecord::Migration[5.0]
  def change
    remove_column :vote_overrides, :type
  end
end
