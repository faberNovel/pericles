class AddIsPublicToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :is_public, :boolean, default: false, null: false
  end
end
