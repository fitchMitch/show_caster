class PollsController < ApplicationController

  def index
    authorize Poll

    @all_polls = {
      expecting_answer: Poll.expecting_answer,
      still_active: Poll.active,
      expired: Poll.passed_ordered.expired
    }
  end

  def edit
  end

  def update
    @poll.update(poll_params)
    flash[:notice] = I18n.t("polls.updated")
    if @poll.save
      redirect_to polls_path, notice: I18n.t("polls.update_success")
    else
      flash[:alert] = I18n.t("polls.save_fails")
      render :edit
    end
  end

  def destroy
    @poll.destroy
    redirect_to polls_url, notice: I18n.t("polls.destroyed")
  end

  def set_type
    type = params.fetch(:type, nil)
    val = (['PollOpinion', 'PollDate'].include? type) ? type : nil
    val.underscore
  end

end
