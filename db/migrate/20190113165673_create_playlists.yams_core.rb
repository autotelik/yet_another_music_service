# This migration comes from yams_core (originally 20181003203725)
class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change

    create_table :playlists do |t|
      t.string :name, index: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    create_table :playlist_tracks do |t|
      t.references :playlist, index: true, foreign_key: true
      t.references :track, index: true, foreign_key: true

      t.integer :sort  # RailsSortable

      t.timestamps
    end

  end
end
