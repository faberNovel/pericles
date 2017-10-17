class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.string :name
      t.text :description
      t.integer :http_method
      t.string :url
      t.json :body_schema
      t.json :response_schema
      t.references :resource, foreign_key: true

      t.timestamps
    end
  end
end
