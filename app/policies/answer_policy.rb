class AnswerPolicy < PollPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
