class AddRequestBodySchemaToRoutes < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :request_body_schema, :json
  end
end