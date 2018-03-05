class DropAttributeFakers < ActiveRecord::Migration[5.1]
  def up
    remove_reference :attributes, :faker, foreign_key: {to_table: :attribute_fakers}, index: true

    drop_table :attribute_fakers
  end

  def down
    create_table :attribute_fakers do |t|
      t.string :name

      t.timestamps
    end

    add_reference :attributes, :faker, foreign_key: {to_table: :attribute_fakers}, index: true
  end
end