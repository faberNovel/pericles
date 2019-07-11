module News
  class MetadatumAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/metadatum/create'
      elsif audit.action == 'update'
        'audits/metadatum/update'
      elsif audit.action == 'destroy'
        'audits/metadatum/destroy'
      end
    end

    def name
      audit.audited_changes['name']
    end

    def url
      metadatum = audit.auditable or return
      h.project_metadata_url(metadatum.project)
    end

    def link_name
      metadatum = audit.auditable or return
      metadatum.name
    end
  end
end
