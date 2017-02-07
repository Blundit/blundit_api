class CreateExpertCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_categories do |t|

      t.timestamps
      t.integer "expert_id"
      t.integer "category_id"
    end
  end
end
