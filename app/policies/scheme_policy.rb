class SchemePolicy < ApplicationPolicy
  def create?
    user.internal?
  end

  def update?
    user.internal?
  end

  def destroy?
    user.internal?
  end
end
