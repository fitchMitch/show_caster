class PerformancesController < EventsController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    authorize(Event)
    @future_performances = Event.future_events.performances
    @passed_performances = Event.passed_events.performances
    # TODO pagination

    @all_events = {nexting: @future_performances, pasting: @passed_performances}
  end

  def new
    authorize(Event)
    @event = Event.new()
    4.times { actor = @event.actors.build }
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
        location: event.theater.location,
        theater_name: event.theater.theater_name,
        event_date: event.event_date.iso8601,
        event_end: (event.event_date + event.duration * 60).iso8601,
        attendees_email: attendees_email
      }
      # special update
      opt[:fk] = event.fk if event.fk.present?
      # TODO opt[:fk] ||= event.fk
      opt
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
