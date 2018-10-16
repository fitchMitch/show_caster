class CoachesController < ApplicationController
  before_action :set_coach, only: [:show, :edit, :update, :destroy]

  # respond_to :html, :json, :js

  def new
    authorize Coach
    @coach = Coach.new
  end

  def index
    authorize Coach
    @coaches = Coach.all
  end

  def show
  end

  def edit
  end

  def create
    @coach = Coach.new(coach_params)
    authorize @coach
    if @coach.save
      redirect_to coaches_path, notice: I18n.t('coaches.save_success')
    else
      flash[:alert] = I18n.t('coaches.save_fails')
      render :new
    end
  end

  def update
    @coach.update(coach_params)
    flash[:notice] = I18n.t('coaches.updated')
    if @coach.save
      redirect_to coaches_path, notice: I18n.t('coaches.update_success')
    else
      flash[:alert] = I18n.t('coaches.save_fails')
      render :edit
    end
  end

  def destroy
    @coach.destroy
    redirect_to coaches_url, notice: I18n.t('coaches.destroyed')
  end

  private
    def set_coach
      @coach = Coach.find(params[:id])
      authorize @coach
    end

    def coach_params
      params.require(:coach).permit(:firstname, :lastname, :email, :note, :cell_phone_nr)
    end
end
