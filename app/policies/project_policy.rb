class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.where(is_public: true) if user.nil?
      user.internal? ? scope.all : scope.left_joins(:members).where("members.user_id = ? OR projects.is_public = true", user.id)
    end
  end

  def index?
    true
  end

  def create?
    user && user.internal?
  end

  def update?
    user && show? && (user.internal? || Project.of_user(user).where(id: record.id).exists?)
  end

  def destroy?
    update?
  end

  def permitted_attributes
    [
      :title,
      :description,
      :proxy_url,
      :mock_profile_id,
      user_ids: []
    ]
  end
end
