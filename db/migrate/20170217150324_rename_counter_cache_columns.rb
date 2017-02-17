class RenameCounterCacheColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :experts, :comments_count, :expert_comments_count

    rename_column :claims, :votes_count, :claim_votes_count
    rename_column :claims, :comments_count, :claim_comments_count

    rename_column :predictions, :votes_count, :prediction_votes_count
    rename_column :predictions, :comments_count, :prediction_comments_count
  end
end
