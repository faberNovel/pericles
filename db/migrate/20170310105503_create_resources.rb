class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
