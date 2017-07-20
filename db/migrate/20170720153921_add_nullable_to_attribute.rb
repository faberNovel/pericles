class AddNullableToAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :nullable, :boolean, null: false, default: false
  end
end
