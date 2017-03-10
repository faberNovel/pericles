class CreateAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :attributes do |t|
      t.string :name
      t.text :description
      t.json :example
      t.integer :parent_resource_id
      t.boolean :is_array, null: false, default: false
      t.integer :primitive_type
      t.references :resource, foreign_key: true

      t.timestamps
    end

    add_foreign_key :attributes, :resources, column: :parent_resource_id
  end
end
