class Events::PicturesController < PicturesController
  before_action :set_imageable

  private
    def set_imageable
      @imageable = Event.find(params[:event_id])
    end
end
