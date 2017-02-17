class UserCounterFixerUpper < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :user_votes_count, :votes_count
  end
end
