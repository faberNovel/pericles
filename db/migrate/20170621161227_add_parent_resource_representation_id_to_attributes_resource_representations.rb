class AddParentResourceRepresentationIdToAttributesResourceRepresentations < ActiveRecord::Migration[5.0]
  def up
    rename_column :attributes_resource_representations, :resource_representation_id, :parent_resource_representation_id
    rename_index :attributes_resource_representations, 'index_arr_on_resource_representation_id',
     'index_arr_on_parent_resource_representation_id'
    add_reference :attributes_resource_representations, :resource_representation, index: false
    add_index :attributes_resource_representations, :resource_representation_id, name: 'index_arr_on_resource_representation_id'
    add_foreign_key :attributes_resource_representations, :resource_representations
  end

  def down
    remove_reference :attributes_resource_representations, :resource_representation, index: true, foreign_key: true
    rename_index :attributes_resource_representations, 'index_arr_on_parent_resource_representation_id',
     'index_arr_on_resource_representation_id'
    rename_column :attributes_resource_representations, :parent_resource_representation_id, :resource_representation_id
  end
end
