class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user&.internal?
  end

  def update?
    index?
  end

  def show?
    index?
  end

  def permitted_attributes
    [:internal]
  end
end
