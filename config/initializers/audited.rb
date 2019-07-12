module Audited
  class Audit < ::ActiveRecord::Base
    belongs_to :project, optional: true

    scope :of_project, ->(project) { where(project: project) }

    before_create :set_project_id

    def decorator_class
      "News::#{auditable_type}AuditDecorator".constantize
    rescue NameError
      News::AuditDecorator
    end

    private

    def set_project_id
      self.project_id ||= auditable&.project&.id
      true
    end
  end
end
