class AddAncestryToMockProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :mock_profiles, :ancestry, :string
    add_index :mock_profiles, :ancestry
  end
end
