class AddKeyToMetadataResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :metadata_responses, :key, :string, null: false, default: ''
  end
end
