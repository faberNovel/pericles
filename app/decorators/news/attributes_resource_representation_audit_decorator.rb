module News
  class AttributesResourceRepresentationAuditDecorator < AuditDecorator
    def destroy_text
      "#{name} has been removed from representation #{url}"
    end

    def update_text
      "#{name} has been updated #{changes} for representation #{url}"
    end

    def created_text
      "#{name} has been added to #{url}"
    end

    def name
      attribute&.name
    end

    def attribute
      attribute_id = audit.auditable&.attribute_id || audit.audited_changes['attribute_id']
      Attribute.find_by(id: attribute_id)
    end

    def url
      resource_representation = audit.associated
      resource = resource_representation&.resource

      if resource_representation
        path = h.project_resource_path(resource.project, resource, anchor: "rep-#{resource_representation.id}")
        h.link_to(resource_representation.name, path)
      else
        'Representation no longer exists'
      end
    end
  end
end
