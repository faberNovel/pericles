class AddIsRequiredToAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :is_required, :boolean, null: false, default: false
  end
end
