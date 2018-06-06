class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def last_audit
    (audits.to_a + associated_audits.to_a).max_by(&:created_at)
  end
end
