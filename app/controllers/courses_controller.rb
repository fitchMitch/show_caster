class CoursesController < EventsController
  before_action :set_polymorphic_courseable_out_of_params, only: [:create, :update]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  # respond_to :html
  # respond_to :html, :json, :js

  def new
    authorize(Course)
    @event = Course.new({ duration: 180})
  end

  def index
    authorize(Course)
    @future_events = Event.courses.future_events
    @passed_events = Event.courses.passed_events
    # TODO pagination
  end

  def create
    @event = Course.new(event_params)
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
        format.html { render :new }
      end
    end
  end

  def set_polymorphic_courseable_out_of_params
    course = params.fetch(:course, nil)
    unless course.nil?
      if course.fetch(:is_autocoached, "1") == "1"
        params["course"]["courseable_type"] = 'User'
        params["course"]["courseable_id"] = course.fetch(:users_list, 0)
      else
        params["course"]["courseable_type"] = 'Coach'
        params["course"]["courseable_id"] = course.fetch(:coaches_list, 0)
      end
    end
  end

  private
    def google_event_params(event)
      opt = {
        title: "g_title.course",
        location: event.theater.location,
        theater_name: event.theater.theater_name,
        event_date: event.event_date.iso8601,
        event_end: (event.event_date + event.duration * 60).iso8601,
        attendees_email: [],
        fk: event.fk
      }
    end

    def set_event
      @event = Event.unscoped.send(set_type.pluralize).find(params[:id])
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
          :theater_id,
          :fk,
          :type,
          :provider,
          :courseable_type,
          :courseable_id
        )
    end

end
