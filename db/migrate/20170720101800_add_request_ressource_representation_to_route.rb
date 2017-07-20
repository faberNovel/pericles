class AddRequestRessourceRepresentationToRoute < ActiveRecord::Migration[5.0]
  def change
    add_reference :routes, :request_resource_representation, references: :resource_representations
    add_foreign_key :routes, :resource_representations, column: :request_resource_representation_id
  end
end
