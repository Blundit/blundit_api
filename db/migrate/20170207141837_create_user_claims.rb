class CreateUserClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :user_claims do |t|

      t.timestamps
      t.integer "user_id"
      t.integer "claim_id"
    end
  end
end
