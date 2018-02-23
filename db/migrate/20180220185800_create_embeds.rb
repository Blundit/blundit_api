class CreateEmbeds < ActiveRecord::Migration[5.0]
  def change
    create_table :embeds do |t|
      t.integer :user_id, length: 11
      t.string :title
      t.text :description
      t.boolean :show_chrome, default: true
      t.timestamps
    end
  end
end
