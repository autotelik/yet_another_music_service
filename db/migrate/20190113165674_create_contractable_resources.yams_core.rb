# This migration comes from yams_core (originally 20181102155021)
class CreateContractableResources < ActiveRecord::Migration[5.2]
  def change

    # Provide linkage between a YAMS resource and back end systems for product management/purchasing
    create_table :contractable_resources do |t|

      t.references :resource, polymorphic: true, index: true

      t.references :spree_product, index: true

      t.timestamps
    end
  end
end
