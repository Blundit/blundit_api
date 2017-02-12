class RenameEvidenceHash < ActiveRecord::Migration[5.0]
  def change
    rename_column :evidences, :hash, :url_content
    
  end
end
