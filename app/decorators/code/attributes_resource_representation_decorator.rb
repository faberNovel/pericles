class Code::AttributesResourceRepresentationDecorator < Draper::Decorator
  include Code::Field
  delegate_all
  delegate :name, :is_array, :primitive_type, :date?, :datetime?, to: :resource_attribute

  def resource
    Code::ResourceRepresentationDecorator.new(resource_representation)
  end

  def code_nullable
    !object.is_required || object.resource_attribute.nullable
  end

  def boolean?
    object.resource_attribute.boolean?
  end

  def enum
    object.resource_attribute.enum
  end
end
