class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|

      t.timestamps
      t.integer "user_id"
      t.integer "vote"
    end
  end
end
