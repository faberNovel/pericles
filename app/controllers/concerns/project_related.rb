module ProjectRelated
  extend ActiveSupport::Concern

  included do
    helper_method :project
  end

  def project
    return @project if defined? @project
    @project = begin
      project = Project.find(params[:project_id])
      policy = ProjectPolicy.new(current_user, project)
      unless policy.show?
        raise Pundit::NotAuthorizedError, query: :show?, record: project, policy: policy
      end
      project
    end
  end

  def pundit_user
    UserContext.new(current_user, project)
  end
end