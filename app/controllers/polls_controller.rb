class PollsController < ApplicationController
  def index
    authorize Poll
    poll_with_voted_opinions = PollOpinion.with_my_opinion_votes(current_user)
                                          .distinct
    poll_with_voted_dates = PollDate.with_my_date_votes(current_user)
                                    .distinct

    @all_polls = {
      voted: poll_with_voted_opinions + poll_with_voted_dates,
      expired: Poll.passed_ordered.expired
    }
    @all_polls[:expecting_answer] = Poll.active - @all_polls[:voted]
  end

  def edit; end

  def update
    flash[:notice] = I18n.t('polls.updated')
    if @poll.update(poll_params)
      redirect_to polls_path, notice: I18n.t('polls.update_success')
    else
      flash[:alert] = I18n.t('polls.save_fails')
      render :edit
    end
  end

  def destroy
    @poll.votes_destroy
    @poll.destroy
    redirect_to polls_url, notice: I18n.t('polls.destroyed')
  end

  def set_type
    type = params.fetch(:type, nil)
    (['PollOpinion', 'PollDate'].include? type) ? type.underscore : nil
  end
end
