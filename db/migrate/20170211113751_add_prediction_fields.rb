class AddPredictionFields < ActiveRecord::Migration[5.0]
  def change
    add_column :predictions, "pass_date", :datetime

  end
end
