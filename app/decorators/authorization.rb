module Authorization
  include ActiveSupport::Concern

  def can_create?(record_class)
    Pundit.policy(object, record_class).create?
  end

  def can_edit?(record)
    Pundit.policy(object, record).edit?
  end

  def can_update?(record)
    Pundit.policy(object, record).update?
  end

  def can_delete?(record)
    Pundit.policy(object, record).destroy?
  end
end