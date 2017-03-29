class CreateJsonErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :json_errors do |t|
      t.text :description
      t.string :type
      t.references :validation, foreign_key: true

      t.timestamps
    end
  end
end
