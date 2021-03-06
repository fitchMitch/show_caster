# frozen_string_literal: true

class VoteOpinionsController < VotesController
  before_action :set_vote, only: %i[show edit update destroy]

  def new
  end

  def create
    @vote = current_user.vote_opinions.new(vote_params)
    authorize @vote
    @answer = Answer.find(@vote.answer_id)
    @vote.poll_id = @answer.poll_id
    @vote.clean_votes
    if @vote.save
      redirect_to polls_path, notice: I18n.t('votes.save_success')
    else
      flash[:alert] = I18n.t('votes.save_fails')
      redirect_to([@vote.poll, @vote])
    end
  end

  private

  def set_vote
    @vote = VoteOpinion.find(params[:id])
    authorize @vote
  end
end
