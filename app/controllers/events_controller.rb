class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # respond_to :html
  # respond_to :html, :json, :js

  def index
    authorize(Event)
    @future_events = Event.future_events
    @passed_events = Event.passed_events
    # TODO pagination

    @all_events = {nexting: @future_events, pasting: @passed_events}
  end

  def show
  end

  def new
    authorize(Event)
    @event = Event.new()
    4.times { actor = @event.actors.build }
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    authorize @event

    @service = GoogleCalendarService.new(current_user)
    result = add_to_google_calendar(@service, @event)
    redirect_to event_path(@event.reload), alert: I18n.t("events.fail_to_create")  and return if result.nil?

    @event.user_id = current_user.id
    @event.fk = result.id
    @event.provider = "google_calendar_v3"

    if @event.save
      redirect_to events_path, notice: I18n.t("events.created")
    else
      respond_to do |format|
        format.html { render :new}
        # format.js
      end
    end
  end

  def update
    @service = GoogleCalendarService.new(current_user)
    Event.transaction do
      if @event.update(event_params)
        result = update_google_calendar(@service, @event)
        if result.nil?
          raise  ActiveRecord::Rollback
          redirect_to events_url, alert: I18n.t("events.google_locked")
        elsif result.is_a? String
          redirect_to events_url, notice: I18n.t("events.updated")
        else
          redirect_to events_url, notice: I18n.t("events.updated_with_Google")
        end
      else
        flash[:notice] = I18n.t("events.desynchronized")
        render 'edit'
      end
    end
  end

  def destroy
    @service = GoogleCalendarService.new(current_user)
    Event.transaction do
      if @event.destroy
        result = delete_google_caldendar(@service, @event)
        if result.nil?
          raise  ActiveRecord::Rollback
          redirect_to events_url, alert: I18n.t("events.google_locked")
        else
          redirect_to events_url, notice: I18n.t("events.destroyed")
        end
      else
        redirect_to event_url(@event), notice: I18n.t("events.fail_to_destroyed")
      end
    end
  end

  private
    def add_to_google_calendar(google_service, event)
      opt = google_event_params(event)
      google_service.add_event_to_primarys(opt)
    end

    def update_google_calendar(google_service, event)
      opt = google_event_params(event)
      google_service.update_event_to_primarys(opt)
    end

    def delete_google_caldendar(google_service, event)
      google_service.delete_event_to_primarys(event)
    end

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
      opt[:fk] = event.fk unless event.fk.nil?
      # TODO opt[:fk] ||= event.fk
      opt
    end

    def set_event
      @event = Event.unscoped.includes(:actors).find(params[:id])
      authorize @event
    end

    def event_params
      params
        .require(:event)
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
