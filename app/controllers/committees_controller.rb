class CommitteesController < ApplicationController
  extend SeasonsHelper
  extend IconsHelper
  @@which_season ||= current_season
  @@season_image ||= extract_icons(1, "png/seasons/#{@@which_season}").first
  before_action :get_season_vars
  before_action :set_committee, only: %i[show edit update destroy]

  # GET /committees
  # GET /committees.json
  def index
    authorize Committee
    @committees = Committee.all

  end

  # GET /committees/1
  # GET /committees/1.json
  def show; end

  # GET /committees/new
  def new
    authorize Committee
    @committee = Committee.new
  end

  # GET /committees/1/edit
  def edit; end

  # POST /committees
  # POST /committees.json
  def create
    @committee = Committee.new(committee_params)
    authorize @committee
    respond_to do |format|
      if @committee.save
        format.html do
          redirect_to committees_path, notice: I18n.t('committees.created_ok')
        end
        format.json { render :show, status: :created, location: @committee }
      else
        format.html { render :new }
        format.json do
          render json: @committee.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /committees/1
  # PATCH/PUT /committees/1.json
  def update
    respond_to do |format|
      if @committee.update(committee_params)
        format.html do
          redirect_to committees_path, notice: I18n.t('committees.updated_ok')
        end
        format.json { render :show, status: :ok, location: @committee }
      else
        format.html { render :edit }
        format.json do
          render json: @committee.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /committees/1
  # DELETE /committees/1.json
  def destroy
    if Committee.allow_to_destroy?
      @committee.redispatch_users
      @committee.destroy
      respond_to do |format|
        format.html do
          redirect_to committees_url, notice: I18n.t('committees.destroyed_ok')
        end
        format.json { head :no_content }
      end
    else
      redirect_to committees_url,
                  danger: I18n.t('committees.destroyed_forbidden')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_committee
      @committee = Committee.find(params[:id])
      authorize @committee
    end

    def committee_params
      params.require(:committee).permit(:name, :mission)
    end

    def get_season_vars
      @season = @@which_season
      @image = @@season_image
    end
end
