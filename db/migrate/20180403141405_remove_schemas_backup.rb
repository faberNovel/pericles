class RemoveSchemasBackup < ActiveRecord::Migration[5.1]
  def change
    remove_column :routes, :request_body_schema_backup, :json
    remove_column :responses, :body_schema_backup, :json
  end
end
