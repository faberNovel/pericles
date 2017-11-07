class AddMinMaxItemsToAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :min_items, :integer
    add_column :attributes, :max_items, :integer
  end
end
