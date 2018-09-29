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
    return false if @user.nil? || @record.nil?
    c1 = @record.status != 'setup'
    c2 = communicator_or_admin?
    c1 && c2 && @record != @user || (User.admin.count > 1)
  end

  def invite?
    create? && @record.setup?
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
