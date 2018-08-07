class VoteDatesController < VotesController
  before_action :set_vote, only: %i[show edit update destroy]
  before_action :set_poll, only: %i[new]

  def new
    authorize VoteDate
    @vote_date = @poll_date.vote_dates.build()
    @answers_votes = []
    @poll_date.answers.each do |answer|
      votes = VoteDate
        .where('poll_id = ?', @poll_date.id)
        .where('answer_id = ?', answer.id)
        .where('user_id = ?', current_user.id)
      vote = votes.any? ? votes.first : nil
      @answers_votes << {answer: answer, vote: vote}
    end
  end

  def create
    @vote = current_user.vote_dates.build(vote_params)
    authorize @vote
    @vote.clean_votes
    if @vote.save
      redirect_to new_poll_date_vote_date_path(@vote.poll_id),
        notice: I18n.t("votes.save_success")
    else
      flash[:alert] = I18n.t("votes.save_fails")
      render :new
    end
  end

  private
    def set_vote
      @vote = VoteDate.find(params[:id])
      authorize @vote
    end

    def set_poll
      @poll_date = PollDate.find(params[:poll_date_id])
    end

end
