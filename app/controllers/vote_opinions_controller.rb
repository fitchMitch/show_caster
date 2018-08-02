class VoteOpinionsController < VotesController
  before_action :set_vote, only: [:show, :edit, :update, :destroy]

  def new
    authorize VoteOpinion
    @poll_opinion = PollOpinion.find(params[:poll_opinion_id]) #TODO ain't exist !
    @vote = @poll_opinion.vote_opinions.build
  end

  def create
    # binding.pry
    @vote = @current_user.vote_opinions.new(vote_params)
    authorize @vote
    @answer = Answer.find(@vote.answer_id)
    @vote.poll_id  = @answer.poll_id
    if @vote.save
      redirect_to polls_path, notice: I18n.t("votes.save_success")
    else
      flash[:alert] = I18n.t("votes.save_fails")
      redirect_to([@vote.poll, @vote])
      # render :new
    end
  end

  private
    def set_vote
      @vote = VoteOpinion.find(params[:id])
      authorize @vote
    end



end
