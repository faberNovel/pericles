class SchemePolicy < ApplicationPolicy
  def create?
    user && user.internal?
  end

  def update?
    user && user.internal?
  end

  def destroy?
    user && user.internal?
  end

  def permitted_attributes
    [:name, :regexp]
  end
end
