class PollDatesController < PollsController
  before_action :set_poll, only: %i[show edit update destroy]

  def show
    @vote_date = @poll.vote_dates.build
    @answers_votes = @poll.fill_answers_votes(current_user)
    @winners = @poll.best_dates_answer.keys
    
    @commontable = @poll
    commontator_thread_show(@commontable)
  end

  private

  def poll_params
    params.require(set_type.to_sym)
          .permit(:question,
                  :expiration_date,
                  answers_attributes: %i[
                    id
                    date_answer
                    poll_id
                    _destroy
                    ]
                  )
  end
end
