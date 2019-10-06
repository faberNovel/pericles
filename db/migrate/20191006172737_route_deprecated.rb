class RouteDeprecated < ActiveRecord::Migration[5.0]
  def up
    add_column :routes, :deprecated, :string
  end

  def down
    remove_column :routes, :deprecated
  end
end
