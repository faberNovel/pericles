class RemoveDescriptionFromHeaders < ActiveRecord::Migration[5.0]
  def change
    remove_column :headers, :description, :text
  end
end
