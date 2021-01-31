class UserPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all.order(:status, :firstname)
      else
        scope.active.order(:firstname)
      end
    end
  end

  def new?
    admin? && light_registration_done?
  end

  def index?
    just_arrived? || light_registration_done?
  end

  def update?
    edit?
  end

  def edit?
    me_only?
  end

  def show?
    me_or_admin?
  end

  def create?
    new?
  end

  def invite?
    admin? && (registered? || registered_with_no_pic?)
  end

  def bio?
    me_or_admin?
  end

  def show_last_connexion?
    light_registration_done? && admin?
  end

  def promote?
    return false unless admin?
    # avoid self eviction as admin in case I'm the last admin
    return false if me_only? && @record&.role != 'admin' && User.admin.count > 1

    true
  end

  def destroy?
    false
  end

  private

    def me_or_admin?
      @user && ((@record&.id == @user&.id) || @user.admin?)
    end

    def me_only?
      @user && (@record&.id == @user&.id)
    end
end
