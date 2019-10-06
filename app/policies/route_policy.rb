class RoutePolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :description,
      :http_method,
      :url,
      :resource_id,
      :security_scheme_id,
      :request_resource_representation_id,
      :request_is_collection,
      :request_root_key,
      :deprecated,
      request_query_parameters_attributes: [
        :id, :name, :description, :primitive_type, :is_optional, :_destroy
      ],
      request_headers_attributes: [:id, :name, :value, :_destroy]
    ]
  end

  def create?
    return false unless super
    return true unless record.is_a? Route
    project.resources.where(id: record.resource_id).exists?
  end

  def rest?
    create?
  end
end
