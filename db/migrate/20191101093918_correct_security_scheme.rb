class CorrectSecurityScheme < ActiveRecord::Migration[5.0]
  def up
    add_column :security_schemes, :description, :string
    add_column :security_schemes, :scheme, :string
    add_column :security_schemes, :bearer_format, :string
    add_column :security_schemes, :flows, :jsonb, default: {}
    add_column :security_schemes, :open_id_connect_url, :string
    rename_column :security_schemes, :parameters, :specification_extensions
  end

  def down
    rename_column :security_schemes, :specification_extensions, :parameters
    remove_column :security_schemes, :open_id_connect_url
    remove_column :security_schemes, :flows
    remove_column :security_schemes, :bearer_format
    remove_column :security_schemes, :scheme
    remove_column :security_schemes, :description
  end
end
