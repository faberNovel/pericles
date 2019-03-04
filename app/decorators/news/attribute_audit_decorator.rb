module News
  class AttributeAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['name']
    end

    def url
      resource = audit.associated
      if resource
        h.link_to(resource.name, h.project_resource_path(resource.project, resource))
      else
        'Associated resource no longer exists'
      end
    end
  end
end
