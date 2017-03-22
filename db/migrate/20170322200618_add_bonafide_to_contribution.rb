class AddBonafideToContribution < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, :bona_fide_id, :integer
  end
end
