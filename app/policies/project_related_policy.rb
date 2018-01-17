class ProjectRelatedPolicy < ApplicationPolicy
  [:create?, :update?, :destroy?].each do |action|
    define_method action do
      project && Pundit.policy(user, project).update?
    end
  end

  def show?
    project && Pundit.policy(user, project).show?
  end

  private

  def project
    super || (record.respond_to?(:project) ? record.project : nil)
  end
end
