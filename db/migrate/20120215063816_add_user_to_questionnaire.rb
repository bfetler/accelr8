class AddUserToQuestionnaire < ActiveRecord::Migration
  def self.up
    add_column :questionnaires, :user_id, :integer
  end

  def self.down
    remove_column :questionnaires, :user
  end
end
