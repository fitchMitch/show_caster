class VotePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    registered?
  end

  def edit?
    registered?
  end

  def index?
    registered?
  end

  def show?
    registered?
  end

  def update?
    edit?
  end

  def create?
    new?
  end

  def destroy?
    create?
  end
end
