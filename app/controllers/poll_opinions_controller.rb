class PollOpinionsController < PollsController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  def new
    authorize PollOpinion
    @poll = PollOpinion.new(
      expiration_date: Date.today.weeks_since(2),
      owner_id: current_user.id)
    2.times { answer = @poll.answers.build() }
  end

  def create
    @poll = PollOpinion.new(poll_params)
    @poll.owner_id = current_user.id
    authorize @poll
    if @poll.save
      @poll.poll_creation_mail
      redirect_to polls_path, notice: I18n.t("polls.save_success")
    else
      flash[:alert] = I18n.t("polls.save_fails")
      render :new
    end
  end

  def show
    @vote = @poll.vote_opinions.build
    @answers_id = VoteOpinion.which_answer(@poll, current_user)
    @answer_id = @answers_id.count > 0 ? @answers_id.first : nil
  end

  private
    def set_poll
      @poll = PollOpinion.find(params[:id])
      authorize @poll
    end

    def poll_params
      params
      .require(set_type.to_sym)
      .permit(
        :question,
        :expiration_date,
        answers_attributes: [
          :id,
          :answer_label,
          :poll_id,
          :_destroy
        ]
       )
    end

end
