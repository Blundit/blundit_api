class AddCommentCount < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, :comments_count, :integer, default: 0
    add_column :predictions, :comments_count, :integer, default: 0
    add_column :claims, :comments_count, :integer, default: 0

    rename_column :predictions, :vote_count, :votes_count
    change_column :predictions, :votes_count, :integer, default: 0

    rename_column :claims, :vote_count, :votes_count
    change_column :claims, :votes_count, :integer, default: 0
  end
end
