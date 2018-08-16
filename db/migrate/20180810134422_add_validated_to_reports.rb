class AddValidatedToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :validated, :boolean, default: true
  end
end
