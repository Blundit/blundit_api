class AddUrlContentToEob < ActiveRecord::Migration[5.0]
  def change
    add_column :evidence_of_beliefs, "url_content", :text
  end
end
