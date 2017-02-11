class SetCountDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :comments_count, :integer, default: 0
    change_column :users, :experts_added, :integer, default: 0
    change_column :users, :predictions_added, :integer, default: 0
    change_column :users, :claims_added, :integer, default: 0
    change_column :users, :votes_count, :integer, default: 0
  end
end
