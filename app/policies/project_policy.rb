class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # TODO: Scope when project role dev
      scope.all
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
