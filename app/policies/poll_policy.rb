class PollPolicy < EventPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    light_registration_done?
  end

  def edit?
    light_registration_done?
  end

  def index?
    light_registration_done?
  end

  def show?
    light_registration_done?
  end

  def update?
    edit?
  end

  def create?
    new?
  end

  def destroy?
    communicator_or_admin?
  end

  private

  def owner?
    record.owner_id = user.id
  end
end
