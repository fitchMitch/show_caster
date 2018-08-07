class VoteOpinionPolicy < VotePolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end



end
