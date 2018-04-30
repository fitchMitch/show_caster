class EventPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    communicator_or_admin?
  end

  def edit?
    !@user.nil?
  end

  def index?
    !@user.nil?
  end

  def show?
    !@user.nil?
  end

  def update?
    edit?
  end

  def create?
    communicator_or_admin?
  end

  def destroy?
    communicator_or_admin?
  end

end
