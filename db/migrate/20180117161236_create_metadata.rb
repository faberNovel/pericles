class CreateMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata do |t|
      t.string :name
      t.integer :primitive_type, default: 0
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
