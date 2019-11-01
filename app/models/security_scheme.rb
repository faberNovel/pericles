class SecurityScheme < ApplicationRecord
  enum security_scheme_type_option: [:apiKey, :http, :oauth2, :openIdConnect]
  enum security_scheme_in_option: [:query, :header, :cookie]

  belongs_to :project, inverse_of: :security_schemes

  validates :key, presence: true, uniqueness: { scope: :project }
  validates :security_scheme_type, presence: true
  validates :project, presence: true

  validate :valid_type_option
  validate :valid_in_option

  validate :required_attributes_by_type
  validate :flows_is_valid_json
  validate :flows_is_hash
  validate :specification_extensions_is_valid_json
  validate :specification_extensions_is_hash

  def flows=(val)
    if val.is_a? String
      val = begin
        JSON.parse(val)
      rescue JSON::ParserError
        val
      end
    end

    super(val)
  end

  def specification_extensions=(val)
    if val.is_a? String
      val = begin
        JSON.parse(val)
      rescue JSON::ParserError
        val
      end
    end

    super(val)
  end

  def valid_type_option
    errors.add(:security_scheme_type, 'invalid choice') if SecurityScheme.security_scheme_type_options[security_scheme_type].nil?
  end

  def valid_in_option
    return if security_scheme_in.blank?
    errors.add(:security_scheme_in, 'invalid choice') if SecurityScheme.security_scheme_in_options[security_scheme_in].nil?
  end

  def required_attributes_by_type
    if security_scheme_type == 'apiKey'
      errors.add(:security_scheme_in, 'required') if security_scheme_in.empty?
      errors.add(:name, 'required') if name.empty?
    elsif security_scheme_type == 'http'
      errors.add(:scheme, 'required') if scheme.empty?
      errors.add(:bearer_format, 'to be set only when scheme is bearer') if scheme != 'bearer' && bearer_format.present?
    elsif security_scheme_type == 'oauth2'
      errors.add(:flows, 'required') if flows.empty?
    elsif security_scheme_type == 'openIdConnect'
      errors.add(:scheme, 'open_id_connect_url') if open_id_connect_url.empty?
    end
  end

  def flows_is_valid_json
    return if flows.empty?
    JSON.parse(specification_extensions) if specification_extensions.is_a? String
  rescue JSON::ParserError
    errors.add(:specification_extensions, 'is not a valid JSON') if specification_extensions.is_a? String
  end

  def flows_is_hash
    return if flows.empty?
    errors.add(:specification_extensions, 'should be a hash') unless specification_extensions.is_a? Hash
  end

  def specification_extensions_is_valid_json
    JSON.parse(specification_extensions) if specification_extensions.is_a? String
  rescue JSON::ParserError
    errors.add(:specification_extensions, 'is not a valid JSON') if specification_extensions.is_a? String
  end

  def specification_extensions_is_hash
    errors.add(:specification_extensions, 'should be a hash') unless specification_extensions.is_a? Hash
  end

  audited
  has_associated_audits
end
