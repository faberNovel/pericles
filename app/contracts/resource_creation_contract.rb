class ResourceCreationContract
  include ActiveModel::Validations

  attr_reader :json_instance, :resource

  validates :json_instance, json_object: true, allow_blank: true
  validate :validate_resource

  delegate :to_key, :to_model, :name, :description, to: :resource

  def initialize(resource, json_instance = nil)
    @resource = resource
    @json_instance = json_instance
  end

  def validate_resource
    resource.valid?
    resource.errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def save
    return false unless valid?

    resource.save
    resource.try_create_attributes_from_json(json_instance) if json_instance
    true
  end

  def class_name
    'Resource'
  end
end
