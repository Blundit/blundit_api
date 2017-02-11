class AddCounterFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, 'comments_count', :integer
    add_column :users, 'experts_added', :integer
    add_column :users, 'predictions_added', :integer
    add_column :users, 'claims_added', :integer
    add_column :users, 'votes_count', :integer
  end
end
