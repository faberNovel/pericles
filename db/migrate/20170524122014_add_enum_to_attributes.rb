class AddEnumToAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :enum, :string
  end
end
