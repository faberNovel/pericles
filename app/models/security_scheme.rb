class SecurityScheme < ApplicationRecord
  belongs_to :project, inverse_of: :security_schemes

  validates :key, presence: true, uniqueness: { scope: :project }
  validates :security_scheme_type, presence: true
  validates :name, presence: true
  validates :security_scheme_in, presence: true
  validates :project, presence: true

  validate :parameters_is_valid_json
  validate :parameters_is_hash

  def parameters=(val)
    if val.is_a? String
      val = begin
        JSON.parse(val)
      rescue JSON::ParserError
        val
      end
    end

    super(val)
  end

  def parameters_is_valid_json
    JSON.parse(parameters) if parameters.is_a? String
  rescue JSON::ParserError
    errors.add(:parameters, 'is not a valid JSON') if parameters.is_a? String
  end

  def parameters_is_hash
    errors.add(:parameters, 'should be a hash') unless parameters.is_a? Hash
  end

  audited
  has_associated_audits
end
