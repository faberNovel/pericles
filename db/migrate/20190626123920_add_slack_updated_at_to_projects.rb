class AddSlackUpdatedAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :slack_updated_at, :datetime
  end
end
