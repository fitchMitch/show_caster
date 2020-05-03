# frozen_string_literal: true

class PollsController < ApplicationController
  def new
    poll_class = set_type.classify.constantize
    authorize poll_class
    @poll = poll_class.new(
      expiration_date: Date.today.weeks_since(2),
      owner_id: current_user.id
    )
    2.times { @poll.answers.build }
  end

  def index
    authorize Poll
    @voted_polls = Poll.polls_with_my_votes(current_user)
    @expired_polls = Poll.passed_ordered.expired
    @expecting_answer_polls = Poll.active - @voted_polls
  end

  def edit; end

  def create
    @poll = set_type.classify.constantize.new(poll_params)
    @poll.owner_id = current_user.id
    @poll.expiration_date = @poll.expiration_date.end_of_day
    authorize @poll
    if @poll.save
      NotificationService.poll_creation(@poll)
      redirect_to polls_path, notice: I18n.t('polls.save_success')
    else
      flash[:alert] = I18n.t('polls.save_fails')
      render :new
    end
  end

  def update
    @poll.expiration_date = @poll.expiration_date.end_of_day
    if @poll.update(poll_params)
      # flash[:notice] = I18n.t('polls.updated')
      NotificationService.poll_notifications_update(@poll)
      redirect_to polls_path, notice: I18n.t('polls.update_success')
    else
      flash[:alert] = I18n.t('polls.save_fails')
      render :edit
    end
  end

  def destroy
    errors = destroy_poll_process(@poll)

    if errors.empty?
      redirect_to polls_url, notice: I18n.t('polls.destroyed')
    else
      Rails.logger.error(errors.join ' ')
      redirect_to polls_url, alert: I18n.t('polls.destroyed_not')
    end
  end

  # protected

  def set_type
    type = params.fetch(:type, nil)
    accepted_classes = %w[PollOpinion PollDate PollSecretBallot]
    (accepted_classes.include? type) ? type.underscore : nil
  end

  private

  def destroy_poll_process(poll)

    errors = []
    Poll.transaction do
      if poll.votes_destroy.nil?
        poll.errors.add(:votes, 'associated votes destroy failed')
      elsif poll.destroy.nil?
        poll.errors.add(:polls, 'poll destroy failed')
      elsif NotificationService.destroy_all_notifications(poll)
        poll.errors.add(
          :notifications,
          'notifications while destroying poll has failed'
        )
      end
      errors = poll.errors.full_messages
      unless errors.empty?
        Rails.logger.error errors.join ": "
        raise ActiveRecord::Rollback
      end
    end
    errors
  end

  def set_poll
    @poll = set_type.classify.constantize.find(params[:id])
    authorize @poll
  end
end
