class MetadatumPolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :name,
      :primitive_type
    ]
  end
end
