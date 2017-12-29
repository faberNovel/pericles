class ProjectRelatedPolicy < ApplicationPolicy
  [:create?, :update?, :show?, :destroy?].each do |action|
    define_method action do
      record.project && Pundit.policy(user, record.project).show?
    end
  end
end
