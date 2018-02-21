class AddIgnoreSslToProxyConfiguration < ActiveRecord::Migration[5.1]
  def change
    add_column :proxy_configurations, :ignore_ssl, :boolean, default: false, null: false
  end
end
