class AddOverridesToCanp < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :permissions, :integer, default: 0
  end
end
