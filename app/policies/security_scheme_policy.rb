class SecuritySchemePolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :key,
      :security_scheme_type,
      :name,
      :security_scheme_in,
      :parameters
    ]
  end
end
