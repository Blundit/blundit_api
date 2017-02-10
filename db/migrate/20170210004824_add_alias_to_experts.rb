class AddAliasToExperts < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, 'alias', :string
  end
end
