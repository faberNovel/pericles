class ResourceRepresentationPolicy < ProjectRelatedPolicy
  def clone?
    create?
  end

  def random?
    show?
  end

  def permitted_attributes_for_create
    [
      :name,
      :description,
      attributes_resource_representations_attributes: [
        :resource_representation_id,
        :custom_key_name,
        :is_required,
        :is_null,
        :attribute_id
      ]
    ]
  end

  def permitted_attributes
    [
      :name,
      :description,
      attributes_resource_representations_attributes: [
        :id,
        :resource_representation_id,
        :custom_key_name,
        :is_required,
        :is_null,
        :attribute_id,
        :_destroy
      ]
    ]
  end
end
