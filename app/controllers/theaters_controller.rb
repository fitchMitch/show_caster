class TheatersController < ApplicationController
  before_action :set_theater, only: [:show, :edit, :update, :destroy]

  # respond_to :html, :json, :js

  def index
    authorize Theater
    @theaters = Theater.all
  end

  def show
  end

  def new
    authorize Theater
    @theater = Theater.new

  end

  def edit
  end

  def create
    @theater = Theater.new(theater_params)
    authorize @theater
    if @theater.save
      redirect_to theaters_path, notice: I18n.t("theaters.save_success")
    else
      flash[:alert] = I18n.t("theaters.save_fails")
      render :new
    end
  end

  def update
    @theater.update(theater_params)
    flash[:notice] = I18n.t("theaters.updated")
    if @theater.save
      redirect_to theaters_path, notice: I18n.t("theaters.update_success")
    else
      flash[:alert] = I18n.t("theaters.save_fails")
      render :edit
    end
  end

  def destroy
    @theater.destroy
    redirect_to theaters_url, notice: I18n.t("theaters.destroyed")
  end

  private
    def set_theater
      @theater = Theater.find(params[:id])
      authorize @theater
    end

    def theater_params
      params.require(:theater).permit(:theater_name, :location, :manager, :manager_phone)
    end
end
