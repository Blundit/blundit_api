class AddWikipediaToExpert < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, "wikipedia", :string
  end
end
