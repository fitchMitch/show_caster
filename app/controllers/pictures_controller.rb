class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
    @events = Event.passed_events
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  # GET /pictures/1/edit
  def edit
  end



  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        @picture.update_column(:photo_updated_at, @picture.photo_updated_at)
        format.html { redirect_to @imageable, notice: I18n.t('pictures.update_success') }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render edit_polymorphic_path([@imageable,@picture]) }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = @imageable.pictures.find(params[:id])
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to @imageable, notice: I18n.t('pictures.destroy_success') }
      format.json { head :no_content }
    end
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(
        :fk,
        :photo,
        :photo_original_w,
        :photo_original_h,
        :photo_crop_x,
        :photo_crop_y,
        :photo_crop_w,
        :photo_crop_h,
        :imageable_id,
        :imageable_type
      )
    end
end
