class CreateMockInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :mock_instances do |t|
      t.string :name
      t.json :body
      t.references :resource, foreign_key: true

      t.timestamps
    end

    add_reference :responses, :mock_instance, foreign_key: true
  end
end
