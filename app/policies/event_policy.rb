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
    communicator_or_admin? && future_event?(@record)
  end

  protected
    def future_event?(record)
      record.present? && record.event_date > Time.zone.now
    end
end
