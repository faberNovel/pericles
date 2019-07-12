module News
  class AttributeAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/attribute/create'
      elsif audit.action == 'update'
        'audits/attribute/update'
      elsif audit.action == 'destroy'
        'audits/attribute/destroy'
      end
    end

    def name
      audit.audited_changes['name']
    end

    def type
      resource = audit.auditable or return
      resource.type
    end

    def url
      resource = audit.associated or return
      h.project_resource_url(resource.project, resource)
    end

    def link_name
      resource = audit.associated or return
      resource.name
    end
  end
end
