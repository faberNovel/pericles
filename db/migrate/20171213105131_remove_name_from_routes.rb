class RemoveNameFromRoutes < ActiveRecord::Migration[5.0]
  def change
    remove_column :routes, :name, :string
  end
end
