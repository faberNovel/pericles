class MockProfilePolicy < ProjectRelatedPolicy
  def edit?
    show?
  end

  def permitted_attributes
    [
      :name,
      :parent_id,
      mock_pickers_attributes: [
        :id,
        :body_pattern,
        :url_pattern,
        :resource_instance_ids,
        :api_error_instance_ids,
        :response_id,
        :_destroy,
        resource_instance_ids: [],
        api_error_instance_ids: [],
        metadatum_instance_ids: []
      ]
    ]
  end
end
