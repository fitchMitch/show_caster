class CommitteePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    admin?
  end

  def index?
    registered?
  end

  def update?
    new?
  end

  def edit?
    new?
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def destroy?
    admin?
  end
end
