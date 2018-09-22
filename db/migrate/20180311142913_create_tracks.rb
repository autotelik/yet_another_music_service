class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :title, index: true
      t.text :description

      t.boolean :streamable
      t.boolean :downloadable

      t.integer :played
      t.integer :downloaded
      t.integer :favourited
      t.integer :commented

      t.string :permalink
      t.string :stream_url
      t.string :download_url

      t.integer :length
      t.integer :bitrate
      t.integer :release_year, limit: 2
      t.integer :release_month, limit: 2
      t.integer :release_day, limit: 2
      t.string :original_format
      t.integer :original_content_size

      t.belongs_to :user, foreign_key: true
      t.belongs_to :license, foreign_key: true
      t.belongs_to :id3_genre, foreign_key: true

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
