# This migration comes from yams_core (originally 20180311142005)
class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :title, index: true
      t.text :description
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
