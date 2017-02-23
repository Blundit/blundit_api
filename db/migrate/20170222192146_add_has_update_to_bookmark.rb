class AddHasUpdateToBookmark < ActiveRecord::Migration[5.0]
  def change
    add_column :bookmarks, "has_update", :boolean, default: false
  end
end
