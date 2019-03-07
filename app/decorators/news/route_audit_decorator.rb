module News
  class RouteAuditDecorator < AuditDecorator
    def name
      audit.audited_changes['url']
    end

    def created_text
      "A new Route #{url} has been created"
    end

    def destroy_text
      "Route #{name} has been deleted"
    end

    def url
      route = audit.auditable
      if route
        h.link_to(route.url, h.project_route_path(route.project, route))
      else
        name
      end
    end
  end
end
