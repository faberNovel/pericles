class CreateApiErrorsAndErrorsInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :api_errors do |t|
      t.string :name
      t.json :json_schema
      t.references :project

      t.timestamps
    end

    add_reference :responses, :api_error, foreign_key: true

    create_table :api_error_instances do |t|
      t.string :name
      t.json :body
      t.references :api_error, foreign_key: true

      t.timestamps
    end

    create_join_table :api_error_instances, :mock_pickers do |t|
      t.index :api_error_instance_id
      t.index :mock_picker_id
    end
  end
end
