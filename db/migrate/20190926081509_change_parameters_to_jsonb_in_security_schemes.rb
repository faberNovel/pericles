class ChangeParametersToJsonbInSecuritySchemes < ActiveRecord::Migration[5.1]
  def up
    remove_column :security_schemes, :parameters
    add_column :security_schemes, :parameters, :jsonb, default: {}
  end

  def down
    remove_column :security_schemes, :parameters, :jsonb
    add_column :security_schemes, :parameters, :string
  end
end
