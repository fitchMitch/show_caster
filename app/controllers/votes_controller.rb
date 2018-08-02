class VotesController < ApplicationController


  # def new
  #   authorize(Vote)
  #   @vote = Vote.new
  # end
  #
  # def create
  #   @vote = Vote.new(vote_params)
  #   authorize @vote
  #   @vote.id = current_user.id
  #   if @vote.save
  #     redirect_to polls_path, notice: I18n.t("votes.save_success")
  #   else
  #     redirect_to polls_path, notice: I18n.t("votes.save_fails")
  #   end
  # end

  def update
  end

  def destroy
  end

  private
    def set_vote
      @vote = Vote.find(params[:id])
      authorize @vote
    end

    def set_type
      type = params.fetch(:type, nil)
      val = (['VoteOpinion', 'VoteDate'].include? type) ? type.underscore : "users"
    end

    def vote_params
      params
        .require(set_type.to_sym)
        .permit(
          :vote_label,
          :answer_id,
          :comment,
          :poll_id,
          :poll_opinion_id,
          :poll_date_id
        )
    end
end
