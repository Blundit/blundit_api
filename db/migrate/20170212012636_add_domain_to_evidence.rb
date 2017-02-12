class AddDomainToEvidence < ActiveRecord::Migration[5.0]
  def change
    add_column :evidences, "domain", :string
  end
end
