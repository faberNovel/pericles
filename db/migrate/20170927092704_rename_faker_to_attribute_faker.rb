class RenameFakerToAttributeFaker < ActiveRecord::Migration[5.0]
  def change
    rename_table :fakers, :attribute_fakers
  end
end
