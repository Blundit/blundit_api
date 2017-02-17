class AddCounterCacheToUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :votes_count, :user_votes_count
    add_column :users, "user_comments_count", :integer, default: 0
  end
end
