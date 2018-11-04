class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|

      t.integer :category, index: true
      t.integer :status, index: true

      t.references :related, polymorphic: true, index: true

      t.timestamps
    end
  end
end
