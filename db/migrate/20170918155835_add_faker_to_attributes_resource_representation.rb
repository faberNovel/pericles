class AddFakerToAttributesResourceRepresentation < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes_resource_representations, :faker, :string
  end
end
