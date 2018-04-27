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
    create? && @record.status != "setup"
  end

  def invite?
    create? && @record.status == "setup"
  end

  def destroy?
    false
  end

  private

    # def promote?
    #   # no possible change on admin if he's the only one left
    #   Member.admin_count == 1 ? (@user.admin? && @record != @user ) : @user.admin?
    # end

    def me_or_admin?
      !@record.nil? && ((@record.id == @user.id) || @user.admin?)
    end

    def googled?
      @user.googled?
    end

    def me_only?
      !@record.nil? && (@record.id == @user.id)
    end
end
