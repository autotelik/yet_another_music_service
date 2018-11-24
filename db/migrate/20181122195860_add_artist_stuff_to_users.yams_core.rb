# This migration comes from yams_core (originally 20180302185933)
class AddArtistStuffToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :bio,  :text
  end
end
