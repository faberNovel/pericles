class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.internal? ? scope.all : scope.of_user(user)
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
