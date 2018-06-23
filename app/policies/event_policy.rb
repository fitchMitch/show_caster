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
    communicator_or_admin?
  end

  def destroy?
    c0 = communicator_or_admin?
    c1 = future_event?(@record)
    c0 && c1
  end

  protected
    def future_event?(record)
      !record.nil? && record.event_date > Time.zone.now
    end
end
