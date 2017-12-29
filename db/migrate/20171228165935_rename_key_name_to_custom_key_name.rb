class RenameKeyNameToCustomKeyName < ActiveRecord::Migration[5.0]
  def change
    remove_column :attributes_resource_representations, :key_name, :string
    add_column :attributes_resource_representations, :custom_key_name, :string
  end
end
