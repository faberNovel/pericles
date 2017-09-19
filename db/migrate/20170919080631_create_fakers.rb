class CreateFakers < ActiveRecord::Migration[5.0]
  def change
    create_table :fakers do |t|
      t.string :name

      t.timestamps
    end

    add_reference :attributes_resource_representations, :faker, foreign_key: true
    remove_column :attributes_resource_representations, :faker, :string
  end
end
