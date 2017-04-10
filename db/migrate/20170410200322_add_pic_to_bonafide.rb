class AddPicToBonafide < ActiveRecord::Migration[5.0]
  def change
    add_column :bona_fides, "pic", :string
  end
end
