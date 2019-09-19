class CreateSecuritySchemes < ActiveRecord::Migration[5.1]
  def up
    create_table :security_schemes do |t|
      t.string :key
      t.string :security_scheme_type
      t.string :name
      t.string :security_scheme_in
      t.text :parameters
      t.references :project, foreign_key: true
    end

    add_reference :routes, :security_scheme, references: :security_schemes
  end

  def down
    remove_reference :routes, :security_scheme

    drop_table :security_schemes
  end
end
