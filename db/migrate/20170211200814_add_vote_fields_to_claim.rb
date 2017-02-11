class AddVoteFieldsToClaim < ActiveRecord::Migration[5.0]
  def change
    add_column :claims, "status", :integer, default: 0
    add_column :claims, "vote_count", :integer, default: 0
    add_column :claims, "vote_value", :float
    remove_column :claims, :accuracy
    remove_column :claims, :added
  end
end
