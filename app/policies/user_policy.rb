class UserPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all.order(:firstname)
      else
        scope.active.order(:firstname)
      end
    end
  end

  def new?
    admin?
  end

  def index?
    registered?
  end

  def update?
    edit?
  end

  def edit?
    me_only?
  end

  def show?
    registered? && me_or_admin?
  end

  def create?
    communicator_or_admin?
  end

  def promote?
    c0 = !(@user.nil? || @record.nil?)
    if c0
      c1 = @record.status != "setup"
      c2 = communicator_or_admin?
      c3 = @record == @user ? (User.admin.count != 1) : true
      c1 && c2 && c3
    end
    # TODO test around this
  end

  def invite?
    create? && @record.status == "setup"
  end

  def destroy?
    false
  end

  private
    def me_or_admin?
      !@user.nil? && !@record.nil? && ((@record.id == @user.id) || @user.admin?)
    end

    def googled?
      @user.googled?
    end

    def me_only?
      !@user.nil? && !@record.nil? && (@record.id == @user.id)
    end
end
