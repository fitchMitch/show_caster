class CoursePolicy < EventPolicy

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
    c0 = communicator_or_admin?
    c1 = future_event?(@record)
    c0 && c1
  end
end
