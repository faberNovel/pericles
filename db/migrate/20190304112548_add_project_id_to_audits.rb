class AddProjectIdToAudits < ActiveRecord::Migration[5.1]
  def up
    add_reference :audits, :project, foreign_key: true, index: true, null: true

    Audited::Audit.reset_column_information
    Audited::Audit.find_each do |audit|
      audit.update(project_id: audit.auditable&.project&.id)
    end
  end

  def down
    remove_reference :audits, :project
  end
end
