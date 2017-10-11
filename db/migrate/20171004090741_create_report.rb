class CreateReport < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :response_status_code
      t.string :response_body
      t.json :response_headers
      t.string :request_body
      t.json :request_headers
      t.string :request_method
      t.string :url
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
