class AddProjectIdToAudits < ActiveRecord::Migration[5.1]
  def change
    add_reference :audits, :project, foreign_key: true, index: true, null: true
  end
end
