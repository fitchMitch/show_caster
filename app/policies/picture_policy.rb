class PicturePolicy < ApplicationPolicy

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
    registered?
  end

  def create?
    registered?
  end

  def destroy?
    registered?
  end



end
