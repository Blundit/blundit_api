class AddContributionFields < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, "expert_id", :integer
    add_column :contributions, "claim_id", :integer
    add_column :contributions, "evidence_id", :integer
    add_column :contributions, "comment_id", :integer
    add_column :contributions, "flag_id", :integer
    add_column :contributions, "prediction_", :integer
  end
end
