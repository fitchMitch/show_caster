class PerformancesController < EventsController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    authorize(Performance)
    @event = Performance.new
    4.times { actor = @event.actors.build }
  end

  def index
    authorize(Performance)
    @future_events = Event.future_events.performances
    @passed_events = Event.passed_events.performances
    # TODO pagination
  end

  def create
    @event = Performance.new(event_params)
    authorize @event

    @service = GoogleCalendarService.new(current_user)
    result = add_to_google_calendar(@service, @event)
    redirect_to event_path(@event.reload), alert: I18n.t("events.fail_to_create")  and return if result.nil?

    @event.fk = result.id
    @event.user_id = current_user.id
    @event.provider = "google_calendar_v3"

    if @event.save
      redirect_to events_url(@event), notice: I18n.t("events.created")
    else
      respond_to do |format|
        format.html { render :new}
      end
    end
  end

  private
    def google_event_params(event)
      attendees_ids = event.actors.pluck(:user_id)
      attendees_email = []
      attendees_ids.each do |id|
        email = User.find_by(id: id).email
        attendees_email << {email: email}
      end

      opt = {
        title: "g_title.performance",
        location: event.theater.location,
        theater_name: event.theater.theater_name,
        event_date: event.event_date.iso8601,
        event_end: (event.event_date + event.duration * 60).iso8601,
        attendees_email: attendees_email,
        fk: event.fk
      }
    end

    def set_event
      @event = Event.unscoped.includes(:actors).send(set_type.pluralize).find(params[:id])
      authorize @event
    end

    def event_params
      params
        .require(set_type.to_sym)
        .permit(
          :event_date,
          :title,
          :duration,
          :note,
          :user_id,
          :theater_id ,
          :progress,
          :uid,
          :fk,
          :provider,
          actors_attributes: [
            :id,
            :user_id,
            :event_id,
            :stage_role,
            :_destroy
          ]
        )
    end

end
