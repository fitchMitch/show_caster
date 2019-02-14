class PerformancesController < EventsController
  before_action :set_event, only: %i[show edit update destroy]

  def new
    authorize(Performance)
    @event = Performance.new(duration: 75, title: 'Cabaret !')
    4.times { @event.actors.build }
  end

  def index
    authorize(Performance)
    if params[:direction] == 'previous'
      @events = Event.passed_events.performances.page params[:page]
    else
      @events = Event.future_events.performances.page params[:page]
    end
  end

  def create
    @event = Performance.new(event_params)
    authorize @event
    @service = GoogleCalendarService.new(current_user)
    result = @service.add_to_google_calendar(@event)
    if result.nil?
      flash[:alert] = I18n.t('performances.fail_to_create')
      format.html { render :new }
    else
      @event.fk = result.id
      @event.user_id = current_user.id
      @event.provider = 'google_calendar_v3'
      if @event.save
        redirect_to events_url(@event), notice: I18n.t('performances.created')
      else
        respond_to do |format|
          format.html { render :new }
        end
      end
    end
  end

  private

  def set_event
    @event = Event.unscoped
                  .includes(:actors)
                  .send(set_type.pluralize)
                  .find(params[:id])
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
        :progress,
        :uid,
        :fk,
        :provider,
        :private_event,
        actors_attributes: %i[
          id
          user_id
          event_id
          stage_role
          _destroy
        ]
      )
  end
end
