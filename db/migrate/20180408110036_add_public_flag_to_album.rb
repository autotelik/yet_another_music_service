class AddPublicFlagToAlbum < ActiveRecord::Migration[5.1]
  def change
    add_column :albums, :published_state, :integer, default: 0
  end
end
