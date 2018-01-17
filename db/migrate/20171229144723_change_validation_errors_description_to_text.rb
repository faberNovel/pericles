class ChangeValidationErrorsDescriptionToText < ActiveRecord::Migration[5.0]
  def up
    change_column :validation_errors, :description, :text
  end

  def down
    change_column :validation_errors, :description, :string
  end
end
