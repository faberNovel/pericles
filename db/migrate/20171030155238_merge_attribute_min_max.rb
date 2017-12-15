class MergeAttributeMinMax < ActiveRecord::Migration[5.0]
  def change
    Attribute.find_each do |a|
      a.minimum = a.min_length unless a.min_length.blank?
      a.maximum = a.max_length unless a.max_length.blank?
    end

    remove_column :attributes, :min_length, :integer
    remove_column :attributes, :max_length, :integer
  end
end
