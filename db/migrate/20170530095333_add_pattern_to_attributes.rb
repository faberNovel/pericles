class AddPatternToAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :attributes, :pattern, :string
  end
end
