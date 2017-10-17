class CreateValidations < ActiveRecord::Migration[5.0]
  def change
    create_table :validations do |t|
      t.text :json_schema
      t.text :json_instance

      t.timestamps
    end
  end
end
