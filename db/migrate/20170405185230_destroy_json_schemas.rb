class DestroyJsonSchemas < ActiveRecord::Migration[5.0]
  def change
    drop_table :json_schemas
  end
end
