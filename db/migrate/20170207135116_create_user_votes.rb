class CreateUserVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_votes do |t|

      t.timestamps
    end
  end
end
