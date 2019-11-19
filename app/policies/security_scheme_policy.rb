class SecuritySchemePolicy < ProjectRelatedPolicy
  def permitted_attributes
    [
      :key,
      :description,
      :security_scheme_type,
      :name,
      :security_scheme_in,
      :scheme,
      :bearer_format,
      :flows,
      :open_id_connect_url,
      :specification_extensions
    ]
  end
end
