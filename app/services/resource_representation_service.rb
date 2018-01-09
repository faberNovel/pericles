class ResourceRepresentationService

  def initialize(resource, representation_by_resource_id={})
    @resource = resource
    @representation_by_resource_id = representation_by_resource_id
  end

  def build_default
    return unless @resource

    resource_representation = @resource.resource_representations.new(
      name: "Default#{@resource.name.capitalize}",
      description: "Automatically generated"
    )
    @representation_by_resource_id[@resource.id] = resource_representation

    @resource.resource_attributes.each do |attribute|
      resource_referenced_by_attribute = @representation_by_resource_id[attribute.resource&.id]
      resource_referenced_by_attribute ||= ResourceRepresentationService.new(attribute.resource, @representation_by_resource_id).build_default
      resource_representation.attributes_resource_representations.new(
        resource_attribute: attribute,
        is_required: true,
        resource_representation: resource_referenced_by_attribute
      )
    end

    resource_representation
  end
end
