class AddSlackToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :slack_incoming_webhook_url, :string
    add_column :projects, :slack_channel, :string
  end
end
