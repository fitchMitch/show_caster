class PollPolicy < EventPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    communicator_or_admin?
  end


end
