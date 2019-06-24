module News
  class ResponseAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/response/create'
      elsif audit.action == 'update'
        'audits/response/update'
      elsif audit.action == 'destroy'
        'audits/response/destroy'
      end
    end

    def type
      audit.auditable_type
    end
    def name
      audit.audited_changes['status_code']
    end

    def link_name
      route = audit.associated or return
      route.url
    end

    def url
      route = audit.associated or return
      h.project_route_url(route.project, route)
    end
  end
end
