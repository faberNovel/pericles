class RemoveBodySchemaFromRoutes < ActiveRecord::Migration[5.0]
  def change
    remove_column :routes, :body_schema, :json
  end
end
