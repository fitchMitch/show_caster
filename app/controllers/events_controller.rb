class EventsController < ApplicationController

  # respond_to :html
  # respond_to :html, :json, :js



  def show
  end

  def edit
  end

  

  def update
    @service = GoogleCalendarService.new(current_user)
    Event.transaction do
      if @event.update(event_params)
        result = update_google_calendar(@service, @event)
        if result.nil?
          raise  ActiveRecord::Rollback
          redirect_to event_url(@event), alert: I18n.t("events.google_locked")
        elsif result.is_a? String
          redirect_to events_url(@event), notice: I18n.t("events.updated")
        else
          redirect_to events_url(@event), notice: I18n.t("events.updated_with_Google")
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
        result = delete_google_calendar(@service, @event)
        if result.nil?
          raise  ActiveRecord::Rollback
          redirect_to events_url(@event), alert: I18n.t("events.google_locked")
        else
          redirect_to events_url(@event), notice: I18n.t("events.destroyed")
        end
      else
        redirect_to event_url(@event), notice: I18n.t("events.fail_to_destroyed")
      end
    end
  end

  private
    def add_to_google_calendar(google_service, event)
      opt = google_event_params(event)
      google_service.add_event_to_g_company_cal(opt)
    end

    def update_google_calendar(google_service, event)
      opt = google_event_params(event)
      google_service.update_event_to_primarys(opt)
    end

    def delete_google_calendar(google_service, event)
      google_service.delete_event_to_primarys(event)
    end

    def set_type
      case params[:type]
      when 'Performance'
        'performance'
      when 'Course'
        'course'
      end
    end

    def events_url(obj)
      obj_type = obj.class.name.pluralize.downcase
      send "#{obj_type}_url".to_sym
    end

    def event_url(obj)
      obj_type = obj.class.name.downcase
      send "#{obj_type}_url".to_sym, obj
    end
end
