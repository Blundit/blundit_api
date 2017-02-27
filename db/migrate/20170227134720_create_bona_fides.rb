class CreateBonaFides < ActiveRecord::Migration[5.0]
  def change
    create_table :bona_fides do |t|
      t.integer  "expert_id"
      t.string   "url"
      t.text     "description"
      t.string   "title"
      t.string   "bona_fide_type"
    end

    rename_column :publications, :url, :domain
    remove_column :publications, :expert_id
    

    add_column :publications, 'pic', :string
    add_column :publications, 'correct_predictions', :integer
    add_column :publications, 'correct_claims', :integer
    add_column :publications, 'incorrect_predictions', :integer
    add_column :publications, 'incorrect_claims', :integer

    add_column :publications, 'prediction_accuracy', :float
    add_column :publications, 'claim_accuracyu', :float

    add_column :publications, 'claims_count', :integer
    add_column :publications, 'predictions_count', :integer
  end
end
