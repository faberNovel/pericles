class CreateHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :headers do |t|
      t.string :name
      t.text :description
      t.references :http_message, polymorphic: true, index: true

      t.timestamps
    end
  end
end
