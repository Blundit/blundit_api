class CreateVoteOverrides < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_overrides do |t|
      t.string :type
      t.string :reason
      t.integer :user_id
      t.integer :prediction_id
      t.integer :claim_id
      t.timestamps
    end
  end
end
