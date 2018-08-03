class CreateVoteSets < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_sets do |t|
      t.integer :user_id, length: 11
      t.string :reason
      t.boolean :active, default: false

      t.timestamps
    end

    add_column :claims, :vote_set_id, :integer
    add_column :predictions, :vote_set_id, :integer
    add_column :votes, :vote_set_id, :integer
  end
end
