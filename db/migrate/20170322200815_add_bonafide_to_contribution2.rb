class AddBonafideToContribution2 < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, :bonafide_id, :integer
  end
end
