class CreateMetadataResponses < ActiveRecord::Migration[5.0]
  def change
    create_table(:metadata_responses) do |t|
      t.references :metadatum, foreign_key: true, index: true
      t.references :response, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
