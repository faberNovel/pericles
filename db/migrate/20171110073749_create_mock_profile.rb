class CreateMockProfile < ActiveRecord::Migration[5.0]
  def change
    create_table :mock_profiles do |t|
      t.references :project
      t.string :name

      t.timestamps
    end

    create_table :mock_pickers do |t|
      t.references :mock_profile, foreign_key: true
      t.references :mock_instance, foreign_key: true
      t.references :response, foreign_key: true
      t.boolean :response_is_favorite
    end

    add_index :mock_pickers, [:mock_profile_id, :response_id], unique: true, name: 'profile_mock_instance_association_unique_index'

    create_join_table :mock_instances, :mock_pickers do |t|
      t.index :mock_instance_id
      t.index :mock_picker_id
    end

    Project.find_each do |p|
      MockProfile.create(project: p, name: 'DefaultMockProfile')
    end
  end
end
