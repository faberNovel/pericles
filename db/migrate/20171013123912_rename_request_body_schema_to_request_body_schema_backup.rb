class RenameRequestBodySchemaToRequestBodySchemaBackup < ActiveRecord::Migration[5.0]
  def change
    rename_column :routes, :request_body_schema, :request_body_schema_backup
  end
end
