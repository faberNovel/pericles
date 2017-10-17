class AddMissingConstraintsInAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :min_length, :integer
    add_column :attributes, :max_length, :integer
    add_column :attributes, :minimum, :integer
    add_column :attributes, :maximum, :integer
  end
end
