module News
  class ResponseAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['status_code']
    end

    def url
      route = audit.associated
      if route
        h.link_to(route.url, h.project_route_path(route.project, route))
      else
        'Route no longer exists'
      end
    end
  end
end
