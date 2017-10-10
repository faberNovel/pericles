class CreateReport < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.boolean :is_valid
      t.integer :status_code
      t.string :body
      t.string :url
      t.json :headers
      t.references :route, foreign_key: true

      t.timestamps null: false
    end
  end
end
