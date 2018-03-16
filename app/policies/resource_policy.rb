class ResourcePolicy < ProjectRelatedPolicy
  def edit_attributes?
    edit?
  end

  def edit_resource?
    edit?
  end
end
