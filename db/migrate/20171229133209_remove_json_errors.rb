class RemoveJsonErrors < ActiveRecord::Migration[5.0]
  def up
    drop_table :json_errors
    ActiveRecord::Base.connection.execute("TRUNCATE validations")
    change_column :validations, :json_schema, 'json USING CAST(json_schema AS json)'
    change_column :validations, :json_instance, 'json USING CAST(json_instance AS json)'
  end

  def down
    change_column :validations, :json_schema, :text
    change_column :validations, :json_instance, :text
    create_table :json_errors do |t|
      t.text :description
      t.string :type
      t.references :validation, foreign_key: true

      t.timestamps
    end
  end
end
