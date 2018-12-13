# This migration comes from yams_core (originally 20181206090304)
class AddArtist < ActiveRecord::Migration[5.1]
  def change
    #rename_column :users, :name, :username  # name to display - aqwan

    add_column :users,  :permalink, :string      # aqwan

    add_column :users,  :permalink_url, :string   # TODO - http://yams.fm/aqwan"  or "http://aqwan.yams.fm" ?

    # same form as Spree as User model
    add_column :users,  :firstname, :string
    add_column :users,  :lastname, :string

    add_column :users,  :city, :string
    add_column :users,  :country, :string
  end
end
