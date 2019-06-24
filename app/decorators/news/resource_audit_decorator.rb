module News
  class ResourceAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/resource/create'
      elsif audit.action == 'update'
        'audits/resource/update'
      elsif audit.action == 'destroy'
        'audits/resource/destroy'
      end
    end

    def name
      audit.audited_changes['name']
    end

    def url
      resource = audit.auditable or return
      h.project_resource_url(resource.project, resource)
    end

    def link_name
      resource = audit.auditable or return
      resource.name
    end
  end
end
