class CreatePredictionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :prediction_categories do |t|

      t.timestamps
      t.integer "prediction_id"
      t.integer "category_id"
    end
  end
end
