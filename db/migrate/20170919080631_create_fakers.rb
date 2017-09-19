class CreateFakers < ActiveRecord::Migration[5.0]
  def change
    create_table :fakers do |t|
      t.string :name

      t.timestamps
    end

    add_reference :attributes, :faker, foreign_key: true
    add_column :attributes_resource_representations, :custom_faker_id, :integer, index: true
    add_foreign_key :attributes_resource_representations, :fakers, column: :custom_faker_id
    remove_column :attributes_resource_representations, :faker, :string
  end
end
