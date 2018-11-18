class PollOpinionsController < PollsController
  before_action :set_poll, only: %i[show edit update destroy]

  def show
    @vote = @poll.vote_opinions.build
    @answers_id = VoteOpinion.which_answer(@poll, current_user)
    @answer_id = @answers_id.count > 0 ? @answers_id.first : nil
    @commontable = @poll
    commontator_thread_show(@commontable)
  end

  private

  def poll_params
    params.require(set_type.to_sym)
          .permit(
            :question,
            :expiration_date,
            answers_attributes: %i[
              id
              answer_label
              poll_id
              _destroy
            ]
          )
  end
end
