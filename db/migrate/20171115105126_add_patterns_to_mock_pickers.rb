class AddPatternsToMockPickers < ActiveRecord::Migration[5.0]
  def change
    change_table :mock_pickers do |t|
      t.column :url_pattern, :string
      t.column :body_pattern, :string
    end

    remove_column :mock_pickers, :response_is_favorite, :boolean
    remove_index :mock_pickers, :column => [:mock_profile_id, :response_id]
  end
end
