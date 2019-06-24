module News
  class ResourceRepresentationAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/resources_representation/create'
      elsif audit.action == 'update'
        'audits/resources_representation/update'
      elsif audit.action == 'destroy'
        'audits/resources_representation/destroy'
      end
    end

    def name
      audit.audited_changes['name']
    end

    def url
      resource_representation = audit.auditable or return
      resource = resource_representation&.resource

      h.project_resource_url(resource.project, resource, anchor: "rep-#{resource_representation.id}")
    end

    def link_name
      resource_representation = audit.auditable or return
      resource_representation.name
    end
  end
end
