class UpdateExpertCategoriesAndBookmark < ActiveRecord::Migration[5.0]
  def change
    add_column :expert_categories, 'source', :boolean, default: 0
    
    add_column :bookmarks, "notify", :boolean, default: 1
  end
end
