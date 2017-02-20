class AddVisibilityToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, "visibility", :boolean, default: true
    add_column :comments, "reason_for_hiding", :string
  end
end
