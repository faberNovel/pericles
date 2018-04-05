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

    begin
      JSON::Validator.fully_validate(
        parent.json_schema, body, json: true
      ).each do |error_message|
        add_error_message(error_message)
      end
    rescue JSON::Schema::JsonParseError
      errors.add(:body, :json_parse_error)
    end
  end

  private

  def add_error_message(error_message)
    unless error_message.include? 'did not match one or more of the required schemas.'
      errors.add(:body, error_message)
      return
    end

    error_message.split("\n- anyOf")[1..-1].each do |error|
      description = error.split("\n    - ")[1..-1].join("\n")
      errors.add(:instance, description)
    end
  end
end