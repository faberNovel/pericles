class CreateMockInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :mock_instances do |t|
      t.string :name
      t.json :body
      t.references :response, foreign_key: true

      t.timestamps
    end

    add_reference :routes, :mock_instance, foreign_key: true
  end
end
