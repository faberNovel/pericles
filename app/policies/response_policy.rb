class ResponsePolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :status_code,
      :resource_representation_id,
      :api_error_id,
      :is_collection,
      :root_key,
      headers_attributes: [:id, :name, :value, :_destroy],
      metadata_responses_attributes: [:id, :metadatum_id, :_destroy]
    ]
  end
end
