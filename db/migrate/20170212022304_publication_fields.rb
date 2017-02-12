class PublicationFields < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, 'expert_id', :integer
    add_column :publications, 'url', :string
    add_column :publications, 'description', :text
    add_column :publications, 'title', :string
  end
end
