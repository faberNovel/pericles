class CreateJsonSchemas < ActiveRecord::Migration[5.0]
  def change
    create_table :json_schemas do |t|
      t.string :name
      t.json :schema
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
