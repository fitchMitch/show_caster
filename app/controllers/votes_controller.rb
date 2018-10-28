class VotesController < ApplicationController
  def update; end

  def destroy; end

  private

  def set_vote
    @vote = Vote.find(params[:id])
    authorize @vote
  end

  def set_type
    type = params.fetch(:type, nil)
    (['VoteOpinion', 'VoteDate'].include? type) ? type.underscore : "users"
  end

  def vote_params
    params
      .require(set_type.to_sym)
      .permit(
        :vote_label,
        :answer_id,
        :poll_id,
        :poll_opinion_id,
        :poll_date_id
      )
  end
end
