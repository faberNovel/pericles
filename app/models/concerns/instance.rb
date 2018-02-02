module Instance
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :mock_pickers

    validates :name, presence: true
    validates :parent, presence: true
    validate :body_valid?
  end

  def parent
    throw 'Implement me !'
  end

  def as_json
    JSON.parse(body)
  end

  def body_valid?
    return unless parent&.json_schema

    JSON::Validator.fully_validate(
      parent.json_schema, body, json: true
    ).each do |error_message|
      errors.add(:body, error_message)
    end
  end
end