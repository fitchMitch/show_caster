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
    scope.where(id: @record.id).exists?
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

  def registered?
    @user&.registered?
  end

  def registered_with_no_pic?
    @user&.registered_with_no_pic?
  end

  def invited?
    @user && @user&.invited?
  end

  def missing_phone_nr?
    @user&.missing_phone_nr? && invited?
  end

  def admin?
    @user&.admin?
  end

  def light_registration_done?
    registered? || registered_with_no_pic? || missing_phone_nr?
  end

  def just_arrived?
    @user && (@user.invited? || @user.invited_to_sign_up?)
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
