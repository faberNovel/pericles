class RemoveCustomFieldsFromResourceRepresentation < ActiveRecord::Migration[5.0]
  def change
    remove_column :attributes_resource_representations, :custom_enum, :string
    remove_column :attributes_resource_representations, :custom_pattern, :string
    remove_column :attributes_resource_representations, :custom_nullable, :boolean
    remove_column :attributes_resource_representations, :custom_faker_id, :boolean
  end
end
