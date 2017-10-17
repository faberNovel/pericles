class CreateAttributesResourceRepresentations < ActiveRecord::Migration[5.0]
  def change
    create_table :attributes_resource_representations do |t|
      t.boolean :is_required, null: false, default: false
      t.string :custom_enum
      t.string :custom_pattern
      t.references :resource_representation, foreign_key: true, index: false
      t.references :attribute, foreign_key: true

      t.timestamps
    end

    add_index :attributes_resource_representations, :resource_representation_id, name: 'index_arr_on_resource_representation_id'
  end
end
