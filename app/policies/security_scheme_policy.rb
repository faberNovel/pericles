class SecuritySchemePolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :key,
      :security_scheme_type,
      :name,
      :in,
      :parameters
    ]
  end

  def create?
    return true
  end
end
