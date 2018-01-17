class ApiErrorPolicy < ProjectRelatedPolicy
  def permitted_attributes
    [:name, :json_schema]
  end
end
