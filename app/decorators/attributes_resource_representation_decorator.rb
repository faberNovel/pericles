class AttributesResourceRepresentationDecorator < Draper::Decorator
  decorates_association :resource_attribute
  delegate_all
end
