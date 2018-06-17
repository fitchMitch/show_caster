class Users::PicturesController < PicturesController
  before_action :set_imageable

  private
    def set_imageable
      @imageable = User.find(params[:user_id])
    end
end
