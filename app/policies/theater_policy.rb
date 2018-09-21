class TheaterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    communicator_or_admin?
  end

  def edit?
    communicator_or_admin?
  end

  def index?
    !@user.nil? && @user.registered?
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
    false
  end
end
