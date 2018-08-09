class PollDatesController < PollsController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  def new
    authorize PollDate
    @poll = PollDate.new(
      expiration_date: Date.today.weeks_since(2),
      owner_id: current_user.id)
    2.times { answer = @poll.answers.build() }
  end

  def create
    @poll = PollDate.new(poll_params)
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

  private
    def set_poll
      @poll = PollDate.find(params[:id])
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
          :date_answer,
          :poll_id,
          :_destroy
        ]
       )
    end

end
