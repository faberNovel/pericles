class RemoveDescriptionFromResponses < ActiveRecord::Migration[5.0]
  def change
    remove_column :responses, :description, :text
  end
end
