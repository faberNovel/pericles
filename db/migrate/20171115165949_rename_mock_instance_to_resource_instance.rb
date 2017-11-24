class RenameMockInstanceToResourceInstance < ActiveRecord::Migration[5.0]
  def change
    rename_table :mock_instances, :resource_instances
    rename_table :mock_instances_pickers, :mock_pickers_resource_instances
    rename_column :mock_pickers_resource_instances, :mock_instance_id, :resource_instance_id

    remove_column :responses, :mock_instance_id, :integer
    remove_column :mock_pickers, :mock_instance_id
  end
end
