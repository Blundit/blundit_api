class FixPublicationTypo < ActiveRecord::Migration[5.0]
  def change
    rename_column :publications, :claim_accuracyu, :claim_accuracy
  end
end
