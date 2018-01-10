class ApplicationPolicy
  attr_reader :user, :project, :record

  def initialize(user_ctx, record)
    if user_ctx.is_a? UserContext
      @user = user_ctx.user
      @project = user_ctx.project
    else
      @user = user_ctx
    end
    @record = record
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(UserContext.new(user, project), record.class)
  end

  class Scope
    attr_reader :user, :project, :scope

    def initialize(user_ctx, scope)
      if user_ctx.is_a? UserContext
        @user = user_ctx.user
        @project = user_ctx.project
      else
        @user = user_ctx
      end
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
