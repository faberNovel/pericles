module News
  class ResourceAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['name']
    end

    def url
      resource = audit.auditable
      if resource
        h.link_to(resource.name, h.project_resource_path(resource.project, resource))
      else
        "Resource #{audit.audited_changes['name']} no longer exists"
      end
    end
  end
end
