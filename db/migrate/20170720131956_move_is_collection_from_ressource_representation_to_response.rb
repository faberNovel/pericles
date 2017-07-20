class MoveIsCollectionFromRessourceRepresentationToResponse < ActiveRecord::Migration[5.0]
  def up
    add_column :responses, :is_collection, :boolean, null: false, default: false
    ResourceRepresentation.where(is_collection: true).each do |representation|
      representation.responses.update_all(is_collection: true)
    end
    remove_column :resource_representations, :is_collection, :boolean
  end

  def down
    add_column :resource_representations, :is_collection, :boolean, null: false, default: false
    Response.where(is_collection: true).each do |response|
      response.resource_representation.update_attributes(is_collection: true)
    end
    remove_column :responses, :is_collection, :boolean
  end
end
