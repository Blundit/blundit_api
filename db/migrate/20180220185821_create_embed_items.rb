class CreateEmbedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :embed_items do |t|
      t.integer :embed_id, length: 11
      t.integer :claim_id, length: 11
      t.integer :prediction_id, length: 11
      t.integer :expert_id, length: 11
      t.timestamps
    end
  end
end
