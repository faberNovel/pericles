class CreateMetadatumInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :metadatum_instances do |t|
      t.string :name
      t.json :body
      t.references :metadatum, foreign_key: true

      t.timestamps
    end

    create_join_table :metadatum_instances, :mock_pickers
  end
end
