# This migration comes from yams_core (originally 20180408110036)
class AddPublicFlagToAlbum < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :published_state, :integer, default: 0
  end
end
