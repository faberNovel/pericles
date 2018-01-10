module ProjectRelated
  extend ActiveSupport::Concern

  included do
    helper_method :project
  end

  def project
    return @project if defined? @project
    @project = begin
      project = find_project
      return unless project

      policy = ProjectPolicy.new(current_user, project)
      unless policy.show?
        raise Pundit::NotAuthorizedError, query: :show?, record: project, policy: policy
      end

      project
    end
  end

  def find_project
    Project.find_by(id: params[:project_id])
  end

  def pundit_user
    UserContext.new(current_user, project)
  end
end