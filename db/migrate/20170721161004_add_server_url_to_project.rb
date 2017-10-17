class AddServerUrlToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :server_url, :string
  end
end
