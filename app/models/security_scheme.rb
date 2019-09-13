class SecurityScheme < ApplicationRecord
  belongs_to :project, inverse_of: :security_schemes

  validates :key, presence: true
  validates :security_scheme_type, presence: true
  validates :name, presence: true
  validates :in, presence: true
  validates :parameters, presence: true
  validates :project, presence: true

  audited
  has_associated_audits
end
