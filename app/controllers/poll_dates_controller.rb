class PollDatesController < PollsController
  before_action :set_poll, only: %i[show edit update destroy]

  def new
    authorize PollDate
    @poll = PollDate.new(
      expiration_date: Date.today.weeks_since(2),
      owner_id: current_user.id
    )
    2.times { @poll.answers.build }
  end

  def show
    @vote_date = @poll.vote_dates.build
    @answers_votes = []
    @poll.answers.each do |answer|
      votes = VoteDate.where('poll_id = ?', @poll.id)
                      .where('answer_id = ?', answer.id)
                      .where('user_id = ?', current_user.id)
      vote = votes.any? ? votes.first : nil
      @answers_votes << { answer: answer, vote: vote }
    end
  end

  private

  def set_poll
    @poll = PollDate.find(params[:id])
    authorize @poll
  end

  def poll_params
    params.require(set_type.to_sym)
          .permit(:question,
                  :expiration_date,
                  answers_attributes: %i[
                    id
                    date_answer
                    poll_id
                    _destroy
                  ])
  end
end
