class AddAliases < ActiveRecord::Migration[5.0]
  def change
    add_column :predictions, 'alias', :string
    add_column :claims, 'alias', :string
  end
end
