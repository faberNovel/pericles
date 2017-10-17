class CreateQueryParameters < ActiveRecord::Migration[5.0]
  def change
    create_table :query_parameters do |t|
      t.string :name
      t.text :description
      t.integer :primitive_type
      t.boolean :is_optional, null: false, default: true
      t.references :route, foreign_key: true

      t.timestamps
    end
  end
end
