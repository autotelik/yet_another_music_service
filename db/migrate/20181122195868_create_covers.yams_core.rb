# This migration comes from yams_core (originally 20180311153005)
class CreateCovers < ActiveRecord::Migration[5.1]
  def change
    create_table :covers do |t|
      t.references :owner, polymorphic: true
      t.timestamps
    end

    create_table :default_covers do |t|
      t.integer :kind, default: 0

      t.timestamps
    end

  end
end
