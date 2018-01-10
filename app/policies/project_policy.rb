class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.internal? ? scope.all : scope.left_joins(:members).where("members.user_id = ? OR projects.is_public = true", user.id)
    end
  end

  def index?
    true
  end

  def create?
    user.internal?
  end

  def update?
    show? && (user.internal? || Project.of_user(user).where(id: record.id).exists?)
  end

  def destroy?
    update?
  end
end
