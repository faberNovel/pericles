class CreateResourceRepresentations < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_representations do |t|
      t.string :name
      t.text :description
      t.references :resource, foreign_key: true

      t.timestamps
    end
  end
end
