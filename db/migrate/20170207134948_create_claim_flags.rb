class CreateClaimFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :claim_flags do |t|

      t.timestamps
      t.integer "claim_id"
      t.integer "flag_id"
    end
  end
end
