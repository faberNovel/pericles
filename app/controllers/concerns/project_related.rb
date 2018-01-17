module ProjectRelated
  extend ActiveSupport::Concern

  included do
    decorates_method :project
  end

  def project
    return @project if defined? @project
    @project = begin
      project = find_project

      policy = ProjectPolicy.new(current_user, project)
      unless policy.show?
        raise Pundit::NotAuthorizedError, query: :show?, record: project, policy: policy
      end

      project
    end
  end

  def find_project
    Project.find(params[:project_id]) if params.has_key? :project_id
  end

  def pundit_user
    UserContext.new(current_user, project)
  end
end