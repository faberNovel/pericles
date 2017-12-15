class RemoveExampleFromResourceAttributes < ActiveRecord::Migration[5.0]
  def change
    remove_column :attributes, :example, :string
  end
end
