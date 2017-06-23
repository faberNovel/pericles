class AddIsCollectionToResourceRepresentations < ActiveRecord::Migration[5.0]
  def change
    add_column :resource_representations, :is_collection, :boolean, null: false, default: false
  end
end
