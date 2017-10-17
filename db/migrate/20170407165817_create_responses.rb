class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.integer :status_code
      t.text :description
      t.json :body_schema

      t.timestamps
    end
  end
end
