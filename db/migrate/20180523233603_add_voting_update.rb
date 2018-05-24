class AddVotingUpdate < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :vote
    add_column :votes, :is_true, :boolean, default: false
    add_column :votes, :is_false, :boolean, default: false
    add_column :votes, :is_unknown, :boolean, default: false
    add_column :votes, :is_unknowable, :boolean, default: false
    add_column :votes, :vote_set_id, :integer
  end
end
