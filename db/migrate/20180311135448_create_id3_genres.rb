class CreateId3Genres < ActiveRecord::Migration[5.1]
  def change
    create_table :id3_genres do |t|
      t.string :name

      t.timestamps
    end
    add_index :id3_genres, :name, unique: true
  end
end
