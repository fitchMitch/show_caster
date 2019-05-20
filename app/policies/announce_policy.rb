class AnnouncePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    registered?
  end

  def index?
    registered?
  end

  def update?
    edit?
  end

  def edit?
    registered?
  end

  def show?
    registered?
  end

  def create?
    new?
  end

  def destroy?
    @record.author == @user.id || @user.admin?
  end
end
