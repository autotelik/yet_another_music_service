# This migration comes from yams_core (originally 20180311142913)
class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|

      t.string :title, index: true
      t.text :description

      t.string :permalink

      t.integer :length, default: 0
      t.integer :bitrate
      t.integer :release_year, limit: 2
      t.integer :release_month, limit: 2
      t.integer :release_day, limit: 2
      t.string :original_format
      t.integer :original_content_size

      t.belongs_to :user, foreign_key: true
      t.belongs_to :license, foreign_key: true

      t.timestamps
    end

    create_table :album_tracks do |t|
      t.references :album, index: true, foreign_key: true
      t.references :track, index: true, foreign_key: true

      t.integer :sort  # RailsSortable

      t.timestamps null: false
    end

  end
end
