class CoachPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    communicator_or_admin?
  end

  def index?
    registered?
  end

  def update?
    edit?
  end

  def edit?
    communicator_or_admin?
  end

  def show?
    registered?
  end

  def create?
    new?
  end

  def destroy?
    false
  end

  private

end
