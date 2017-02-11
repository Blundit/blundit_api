class AddFieldsToEvidences < ActiveRecord::Migration[5.0]
  def change
    add_column :evidences, "image", :string
    add_column :evidences, "hash", :text
  end
end
