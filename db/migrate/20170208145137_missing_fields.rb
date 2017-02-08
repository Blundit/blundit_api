class MissingFields < ActiveRecord::Migration[5.0]
  def change
      add_column :user_contributions, "user_id", :integer
      add_column :user_contributions, "contribution_id", :integer

      add_column :user_comments, "user_id", :integer
      add_column :user_comments, "comment_id", :integer

      add_column :user_flags, "user_id", :integer
      add_column :user_flags, "flag_id", :integer

      add_column :user_votes, "user_id", :integer
      add_column :user_votes, "vote_id", :integer
  end
end
