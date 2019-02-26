class AddNullableToMetadata < ActiveRecord::Migration[5.1]
  def change
    add_column :metadata, :nullable, :boolean, null: false, default: true
  end
end
