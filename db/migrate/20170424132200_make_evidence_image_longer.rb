class MakeEvidenceImageLonger < ActiveRecord::Migration[5.0]
  def change
    change_column :evidences, :image, :text
  end
end
