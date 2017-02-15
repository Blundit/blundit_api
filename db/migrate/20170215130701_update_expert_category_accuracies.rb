class UpdateExpertCategoryAccuracies < ActiveRecord::Migration[5.0]
  def change
    rename_column :expert_category_accuracies, :incorrect, :incorrect_claims
    rename_column :expert_category_accuracies, :correct, :correct_claims
    rename_column :expert_category_accuracies, :accuracy, :claim_accuracy

    add_column :expert_category_accuracies, "prediction_accuracy", :float
    add_column :expert_category_accuracies, "overall_accuracy", :float

    add_column :expert_category_accuracies, "incorrect_predictions", :integer
    add_column :expert_category_accuracies, "correct_predictions", :integer

  end
end
