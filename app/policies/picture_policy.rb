class PicturePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def edit?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

end