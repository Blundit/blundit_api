class CreateClaimVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_votes do |t|

      t.timestamps
      t.integer "claim_id"
      t.integer "vote_id"
    end
  end
end
