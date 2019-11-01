class AddOperationId < ActiveRecord::Migration[5.0]
  def up
    add_column :routes, :operation_id, :string
  end

  def down
    remove_column :routes, :operation_id
  end
end
