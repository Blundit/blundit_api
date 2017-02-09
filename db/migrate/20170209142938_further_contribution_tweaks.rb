class FurtherContributionTweaks < ActiveRecord::Migration[5.0]
  def change
    rename_column :contributions, :prediction_, :prediction_id
    add_column :contributions, "payload", :text
  end
end
