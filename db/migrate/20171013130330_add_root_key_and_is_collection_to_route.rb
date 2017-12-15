class AddRootKeyAndIsCollectionToRoute < ActiveRecord::Migration[5.0]
  def change
    rename_column :routes, :is_collection, :request_is_collection
    change_column_null :routes, :request_is_collection, false
    change_column_default :routes, :request_is_collection, false
    add_column :routes, :request_root_key, :string
  end
end
