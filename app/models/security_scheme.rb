class SecurityScheme < ApplicationRecord
  enum security_scheme_type_option: [:apiKey, :http, :oauth2, :openIdConnect]
  enum security_scheme_in_option: [:query, :header, :cookie]

  belongs_to :project, inverse_of: :security_schemes

  validates :key, presence: true, uniqueness: { scope: :project }
  validates :security_scheme_type, presence: true
  validates :project, presence: true

  validates :security_scheme_type, inclusion: { in: security_scheme_type_options.keys }
  validates :security_scheme_in, inclusion: { in: security_scheme_in_options.keys }, allow_blank: true
  validates :specification_extensions, json: true, hash: true
  validates :flows, json: true, hash: true

  validate :required_attributes_by_type

  def flows=(val)
    super(ValidationsHelper.parse_json_text(val))
  end

  def specification_extensions=(val)
    super(ValidationsHelper.parse_json_text(val))
  end

  def required_attributes_by_type
    case security_scheme_type
    when 'apiKey'
      errors.add(:security_scheme_in, 'required') if security_scheme_in.empty?
      errors.add(:name, 'required') if name.empty?
    when 'http'
      errors.add(:scheme, 'required') if scheme.empty?
      errors.add(:bearer_format, 'to be set only when scheme is bearer') if scheme != 'bearer' && bearer_format.present?
    when 'oauth2'
      errors.add(:flows, 'required') if flows.empty?
    when 'openIdConnect'
      errors.add(:scheme, 'open_id_connect_url') if open_id_connect_url.empty?
    end
  end

  audited
  has_associated_audits
end
