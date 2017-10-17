class AddRequestDescriptionToRoutes < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :request_description, :text
  end
end
