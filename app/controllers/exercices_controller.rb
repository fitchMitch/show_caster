class ExercicesController < ApplicationController
  before_action :set_exercice, only: %i[show edit update destroy]

  # respond_to :html, :json, :js

  def index
    authorize Exercice
    @q = Exercice.ransack(params[:q])
    @exercices = @q.result(distinct: true)
                   .page(params[:page])
                   .per(15)
                   
  end

  def show; end

  def new
    authorize Exercice
    @exercice = Exercice.new
  end

  def edit; end

  def create
    @exercice = Exercice.new(
      exercice_params.merge(
        skill_list: params[:exercice][:skill_list]
      )
    )
    authorize @exercice
    if @exercice.save
      redirect_to exercices_path, notice: I18n.t('exercices.save_success')
    else
      flash[:alert] = I18n.t('exercices.save_fails')
      render :new
    end
  end

  def update
    @exercice.update(
      exercice_params.merge(
        skill_list: params[:exercice][:skill_list]
      )
    )

    flash[:notice] = I18n.t('exercices.updated')
    if @exercice.save
      redirect_to exercices_path, notice: I18n.t('exercices.update_success')
    else
      flash[:alert] = I18n.t('exercices.save_fails')
      render :edit
    end
  end

  def destroy
    if @exercice.destroy
      redirect_to exercices_url, notice: I18n.t('exercices.destroyed')
    else
      redirect_to exercice_path(@exercice),
                  alert: I18n.t('exercices.fail_to_destroy')
    end
  end

  private

  def set_exercice
    @exercice = Exercice.find(params[:id])
    authorize @exercice
  end

  def exercice_params
    params.require(:exercice)
          .permit(
            :title,
            :instructions,
            :category,
            :energy_level,
            :max_people,
            :promess,
            :focus,
            skill_lists: []
          )
  end
end
