class AddApiGatewayIntegration < ActiveRecord::Migration[5.1]
  def up
    create_table :api_gateway_integrations do |t|
      t.string :title
      t.string :uri_prefix
      t.integer :timeout_in_millis
      t.references :project, foreign_key: true, index: true
    end
  end

  def down
    drop_table :api_gateway_integrations
  end
end
