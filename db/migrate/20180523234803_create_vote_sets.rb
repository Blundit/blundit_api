class CreateVoteSets < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_sets do |t|
      t.integer :claim_id
      t.integer :prediction_id
      t.boolean :current
      t.boolean :type, default: 0 
      t.string :status
      t.timestamps
    end
  end
end
