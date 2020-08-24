# frozen_string_literal: true

class PerformancesController < EventsController
  before_action :set_event, only: %i[show edit update destroy]

  def new
    authorize(Performance)
    @event = Performance.new(duration: 75, title: 'Cabaret !')
    4.times { @event.actors.build }
  end

  def index
    authorize(Performance)
    @all_events = Event.performances
    @events = if params[:direction] == 'previous'
                @all_events.passed_events.page params[:page]
              elsif params[:direction] == 'next'
                @all_events.future_events.page params[:page]
              else
                @all_events.future_events.page params[:page]
              end
  end

  def create
    @event = Performance.new(event_params)
    authorize @event
    @event.user_id = current_user.id
    if @event.save
      redirect_to events_url(@event),
                  notice: I18n.t('performances.created')
    else
      respond_to do |format|
        format.html { render :new }
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
