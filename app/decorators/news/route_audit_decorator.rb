module News
  class RouteAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/route/create'
      elsif audit.action == 'update'
        'audits/route/update'
      elsif audit.action == 'destroy'
        'audits/route/destroy'
      end
    end

    def name
      audit.audited_changes['url']
    end

    def url
      route = audit.auditable or return
      h.project_resource_url(route.project, route)
    end

    def link_name
      route = audit.auditable or return
      route.url
    end
  end
end
