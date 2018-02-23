class AddEmbedViewCount < ActiveRecord::Migration[5.0]
  def change
    add_column :embeds, :embed_views_count, :integer, default: 0
  end
end
