class AddKeyToEmbed < ActiveRecord::Migration[5.0]
  def change
    add_column :embeds, :key, :string
  end
end
