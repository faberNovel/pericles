module Audited
  class Audit < ::ActiveRecord::Base
    belongs_to :project, optional: true

    scope :of_project, ->(project) { where(project: project) }

    before_create :set_project_id

    private

    def set_project_id
      self.project_id ||= auditable&.project&.id
      true
    end
  end
end
