# frozen_string_literal: true

class AnnouncesController < ApplicationController
  before_action :set_announce, only: %i[show edit update destroy]

  # GET /announces
  # GET /announces.json
  def index
    @announces = Announce.all.order(time_end: :desc)
  end

  # GET /announces/1
  # GET /announces/1.json
  def show; end

  # GET /announces/new
  def new
    time_start = DateTime.current.advance(weeks: 3)
    time_end = DateTime.current.advance(weeks: 4)
    @announce = Announce.new(time_start: time_start, time_end: time_end)
  end

  # GET /announces/1/edit
  def edit; end

  # POST /announces
  # POST /announces.json
  def create
    @announce = Announce.new(announce_params)

    respond_to do |format|
      @announce.author_id = current_user.id
      if @announce.save
        format.html do
          redirect_to announces_path,
                      notice: I18n.t('announces.created_ok')
        end
        format.json { render :show, status: :created, location: @announce }
      else
        format.html { render :new }
        format.json do
          render json: @announce.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /announces/1
  # PATCH/PUT /announces/1.json
  def update
    respond_to do |format|
      if @announce.update(announce_params)
        format.html do
          redirect_to announces_path,
                      notice: I18n.t('announces.updated_ok')
        end
        format.json { render :show, status: :ok, location: @announce }
      else
        format.html { render :edit }
        format.json do
          render json: @announce.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /announces/1
  # DELETE /announces/1.json
  def destroy
    @announce.destroy
    respond_to do |format|
      format.html do
        redirect_to announces_url,
                    notice: I18n.t('announces.destroyed_ok')
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announce
    @announce = Announce.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def announce_params
    params.require(:announce)
          .permit(:author_id,
                  :time_start,
                  :time_end,
                  :title,
                  :body)
  end
end
