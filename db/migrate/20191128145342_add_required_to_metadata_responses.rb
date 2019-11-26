class AddRequiredToMetadataResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :metadata_responses, :required, :boolean, default: false
  end
end
