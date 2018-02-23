class AddMissingEmbedFields < ActiveRecord::Migration[5.0]
  def change
    add_column :embeds, :user_id, :integer, length: 11
    add_column :embeds, :title, :string
    add_column :embeds, :description, :text
    add_column :embeds, :show_chrome, :boolean, default: true
  end
end
