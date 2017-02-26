class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar
    end

    # change_table :experts do |t|
    #   t.attachment :avatar
    # end

    change_table :predictions do |t|
      t.attachment :pic
    end

    change_table :claims do |t|
      t.attachment :pic
    end
  end

  def self.down
    remove_attachment :users, :avatar
    remove_attachment :experts, :avatar
    remove_attachment :predictions, :pic
    remove_attachment :claims, :pic
  end
end
