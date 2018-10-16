class Events::PicturesController < PicturesController
  before_action :set_imageable

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = @imageable.pictures.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @imageable, notice: I18n.t('pictures.save_success')  }
        format.json { render :show, status: :created, location: @imageable }
      else
        format.html { redirect_to @imageable, notice: I18n.t('pictures.save_failure')  }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    #  performances only have pictures
    def set_imageable
      @imageable = Event.find(params[:performance_id])
    end
end
