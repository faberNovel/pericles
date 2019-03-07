module News
  class ResourceAuditDecorator < AuditDecorator
    def name
      "<b>#{audit.audited_changes['name']}</b>"
    end

    def created_text
      "A new Resource #{url} has been created"
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
