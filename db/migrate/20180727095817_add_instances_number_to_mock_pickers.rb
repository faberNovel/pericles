class AddInstancesNumberToMockPickers < ActiveRecord::Migration[5.1]
  def change
    add_column :mock_pickers, :instances_number, :integer
  end
end
