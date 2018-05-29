class AddUniqueConstraintToAttributeName < ActiveRecord::Migration[5.1]
  def change
    add_index :attributes, [:parent_resource_id, :name], unique: true
  end
end
