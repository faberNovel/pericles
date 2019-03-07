module News
  class ResourceRepresentationAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['name']
    end

    def created_text
      "A new ResourceRepresentation #{url} has been created"
    end

    def url
      resource_representation = audit.auditable
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
