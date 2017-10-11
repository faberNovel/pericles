class CreateReport < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :status_code
      t.string :body
      t.string :url
      t.json :headers
      t.references :route, foreign_key: true

      t.timestamps null: false
    end

    create_table :validation_errors do |t|
      t.integer :category
      t.string :description
      t.references :report, foreign_key: true

      t.timestamps null: false
    end
  end
end
