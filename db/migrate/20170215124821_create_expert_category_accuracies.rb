class CreateExpertCategoryAccuracies < ActiveRecord::Migration[5.0]
  def change
    create_table :expert_category_accuracies do |t|
      t.integer "category_id"
      t.integer "expert_id"
      t.float "accuracy"
      t.integer "correct", default: 0
      t.integer "incorrect", default: 0
      t.timestamps
    end
  end
end
