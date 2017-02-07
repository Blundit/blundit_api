class AddClaimidToClaimComments < ActiveRecord::Migration[5.0]
  def change
    add_column :claim_comments, "claim_id", :integer
  end
end
