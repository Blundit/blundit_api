class CreateEmbedViews < ActiveRecord::Migration[5.0]
  def change
    create_table :embed_views do |t|
      t.string :ip
      t.integer :embed_id, length: 11
      t.timestamps
    end
  end
end
