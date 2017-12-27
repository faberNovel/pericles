class AddKeyNameToAttributesResourceRepresentation < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes_resource_representations, :key_name, :string

    AttributesResourceRepresentation.find_each do |attributes_resource_representation|
      attributes_resource_representation.key_name = attributes_resource_representation.resource_attribute.default_key_name
      attributes_resource_representation.save
    end
  end
end
