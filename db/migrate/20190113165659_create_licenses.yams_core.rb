# This migration comes from yams_core (originally 20180311140751)
class CreateLicenses < ActiveRecord::Migration[5.1]
  def change
    create_table :licenses do |t|
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
