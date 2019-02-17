# This migration comes from yams_core (originally 20180302185953)
class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer
  end
end
