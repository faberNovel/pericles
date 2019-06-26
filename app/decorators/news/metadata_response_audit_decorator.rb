module News
  class MetadataResponseAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/metadata_response/create'
      elsif audit.action == 'update'
        'audits/metadata_response/update'
      elsif audit.action == 'destroy'
        'audits/metadata_response/destroy'
      end
    end

    def name
      metadatum&.name
    end

    def metadatum
      metadatum_id = audit.auditable&.metadatum_id || audit.audited_changes['metadatum_id']
      Metadatum.find_by(id: metadatum_id)
    end

    def response
      response_id = audit.auditable&.response_id || audit.audited_changes['response_id']
      Response.find_by(id: response_id)
    end

    def route
      response&.route
    end

    def link_name
      "response #{response.status_code} on #{route.url}"
    end

    def url
      return unless response
      h.project_route_url(route.project, route, anchor: "resp-#{response.id}")
    end
  end
end
