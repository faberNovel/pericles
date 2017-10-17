class AddIsCollectionToRoutes < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :is_collection, :boolean, default: false, null: false
  end
end
