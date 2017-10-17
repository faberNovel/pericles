class AddCustomNullableToAttributesResourceRepresentations < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes_resource_representations, :custom_nullable, :boolean
  end
end
