# frozen_string_literal: true

class Users::PicturesController < PicturesController
  before_action :set_imageable

  # POST /pictures
  # POST /pictures.json
  def create
    # First destroy
    @imageable.pictures.first.destroy unless @imageable.pictures.empty?
    @picture = @imageable.pictures.new(picture_params)
    respond_to do |format|
      if @picture.save
        current_user.update_status({}).save if @imageable.class.name == 'User'
        format.html do
          redirect_to @imageable, notice: I18n.t('pictures.save_success')
        end
        format.json { render :show, status: :created, location: @imageable }
      else
        format.html do
          redirect_to @imageable, notice: I18n.t('pictures.save_failure')
        end
        format.json do
          render json: @picture.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_imageable
    @imageable = User.find(params[:user_id])
  end
end
