class PollSecretBallotPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    admin?
  end

  def edit?
    new?
  end

  def index?
    registered?
  end

  def show?
    registered?
  end

  def update?
    admin?
  end

  def create?
    new?
  end

  def destroy?
    create?
  end
end
