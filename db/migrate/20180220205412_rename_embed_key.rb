class RenameEmbedKey < ActiveRecord::Migration[5.0]
  def change
    rename_column :embeds, :key, :embed_key
  end
end
