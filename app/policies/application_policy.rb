class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    #raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => @record.id).exists?
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

  protected

    def communicator_or_admin?
      (@user.nil? || @user.archived?) ? false : (@user.admin? || @user.admin_com?)
    end

    def fully_registered?
      !@user.nil? && @user.fully_registered?
    end

    def admin?
      !@user.nil? && @user.admin?
    end

    def scope
      Pundit.policy_scope!(@user, record.class)
    end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
