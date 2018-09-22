class CreateAvailables < ActiveRecord::Migration[5.1]
  def change
    create_table :availables do |t|
      t.references :type, polymorphic: true, index: true
      t.integer :mode, index: true
      t.datetime :on
      t.datetime :expires, default: nil
    end
  end
end
