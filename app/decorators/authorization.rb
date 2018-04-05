module Authorization
  extend ActiveSupport::Concern

  def can_create?(record_class, options = {})
    Pundit.policy(UserContext.new(object, options[:project]), record_class).create?
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