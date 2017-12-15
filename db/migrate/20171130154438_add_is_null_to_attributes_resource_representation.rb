class AddIsNullToAttributesResourceRepresentation < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes_resource_representations, :is_null, :boolean, default: false, null: false
  end
end
