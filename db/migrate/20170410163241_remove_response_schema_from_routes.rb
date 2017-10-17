class RemoveResponseSchemaFromRoutes < ActiveRecord::Migration[5.0]
  def change
    remove_column :routes, :response_schema, :json
  end
end

