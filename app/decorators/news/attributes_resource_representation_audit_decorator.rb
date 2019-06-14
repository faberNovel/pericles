module News
  class AttributesResourceRepresentationAuditDecorator < AuditDecorator
    def partial_name
      if audit.action == 'create'
        'audits/attributes_resource_representation/create'
      elsif audit.action == 'update'
        'audits/attributes_resource_representation/update'
      elsif audit.action == 'destroy'
        'audits/attributes_resource_representation/destroy'
      end
    end

    def name
      attribute&.name
    end

    def action_css_class
      'update'
    end

    def attribute
      attribute_id = audit.auditable&.attribute_id || audit.audited_changes['attribute_id']
      Attribute.find_by(id: attribute_id)
    end

    def link_name
      resource_representation = audit.associated
      resource_representation&.name
    end

    def url
      resource_representation = audit.associated
      resource = resource_representation&.resource

      if resource_representation
        h.project_resource_url(resource.project, resource, anchor: "rep-#{resource_representation.id}")
      end
    end
  end
end
