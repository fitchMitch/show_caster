# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy]

  def index
    authorize Answer
    @answers = Answer.all
  end

  def show; end

  def new
    authorize Answer
    @answer = Answer.new
  end

  def edit; end

  def create
    @answer = Answer.new(answer_params)
    authorize @answer
    if @answer.save
      redirect_to answers_path, notice: I18n.t('answers.save_success')
    else
      flash[:alert] = I18n.t('answers.save_fails')
      render :new
    end
  end

  def update
    # @answer
    # flash[:notice] = I18n.t('answers.updated')
    if @answer.update(answer_params)
      redirect_to answers_path, notice: I18n.t('answers.update_success')
    else
      flash[:alert] = I18n.t('answers.save_fails')
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to answers_url, notice: I18n.t('answers.destroyed')
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def answer_params
    params.require(:answer).permit(:answer_label, :date_answer, :poll_id)
  end
end
