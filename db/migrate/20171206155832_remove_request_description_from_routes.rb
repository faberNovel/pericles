class RemoveRequestDescriptionFromRoutes < ActiveRecord::Migration[5.0]
  def change
    remove_column :routes, :request_description, :text
  end
end
