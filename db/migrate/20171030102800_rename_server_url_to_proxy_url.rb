class RenameServerUrlToProxyUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :server_url, :proxy_url
  end
end
