class AddExpertFields < ActiveRecord::Migration[5.0]
  def change
    add_column :experts, "website", :string
    add_column :experts, "occupation", :string
    add_column :experts, "country", :string
    add_column :experts, "city", :string
  end
end
