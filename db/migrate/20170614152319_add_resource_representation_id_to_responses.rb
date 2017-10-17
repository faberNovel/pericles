class AddResourceRepresentationIdToResponses < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :resource_representation, foreign_key: true
  end
end
