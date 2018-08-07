class PollPolicy < EventPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def edit?
    communicator_or_admin? || owner?
  end

  def index?
    registered?
  end

  def show?
    true
  end

  def update?
    edit?
  end

  def create?
    new?
  end

  def destroy?
    admin?
  end


  private
    def owner?
      record.owner_id = user.id
    end


end
