module News
  class AttributeAuditDecorator < AuditDecorator
    def name
      "<b>#{audit.audited_changes['name']}</b>"
    end

    def created_text
      "#{url} has a new attribute #{name} (#{type})"
    end

    def update_text
      "#{audit.auditable_type} #{audit.auditable&.name} of #{url} has been updated: #{changes}"
    end

    def type
      resource = audit.auditable or return
      resource.type
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
