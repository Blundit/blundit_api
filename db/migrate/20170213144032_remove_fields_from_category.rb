class RemoveFieldsFromCategory < ActiveRecord::Migration[5.0]
  def change
    remove_column :categories, :user_id
    remove_column :categories, :claim_id
    remove_column :categories, :prediction_id
    remove_column :categories, :expert_id

  end
end
