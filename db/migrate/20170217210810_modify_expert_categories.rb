class ModifyExpertCategories < ActiveRecord::Migration[5.0]
  def change
    change_column :expert_categories, :source, :boolean, default: 0
  end
end
