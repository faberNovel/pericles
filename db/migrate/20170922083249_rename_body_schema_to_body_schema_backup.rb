class RenameBodySchemaToBodySchemaBackup < ActiveRecord::Migration[5.0]
  def change
    rename_column :responses, :body_schema, :body_schema_backup
  end
end
