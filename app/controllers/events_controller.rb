class EventsController < ApplicationController

  def edit; end

  def show; end

  def update
    if @event.update(event_params)
      @service = GoogleCalendarService.new(current_user)
      result = update_google_calendar(@service, @event)
      if result.is_a? String
        redirect_to events_url(@event),
                    notice: I18n.t('events.desynchronized')
      else
        redirect_to events_url(@event),
                    notice: I18n.t('events.updated_with_Google')
      end
    else
      flash[:notice] = I18n.t('events.update_failed')
      render 'edit'
    end

    # @service = GoogleCalendarService.new(current_user)
    # result = update_google_calendar(@service, event_params)
    # if result.nil?
    #   redirect_to event_url(@event),
    #               alert: I18n.t('performances.google_locked')
    # elsif @event.update(event_params)
    #   if result.is_a? String
    #     redirect_to events_url(@event),
    #                 notice: I18n.t('performances.updated')
    #   else
    #     redirect_to events_url(@event),
    #                 notice: I18n.t('performances.updated_with_Google')
    #   end
    # else
    #   flash[:notice] = I18n.t('performances.desynchronized')
    #   render 'edit'
    # end
  end

  def destroy
    @service = GoogleCalendarService.new(current_user)
    if @event.destroy
      result = delete_google_calendar(@service, @event)
      if result.nil?
        redirect_to events_url(@event),
                    alert: I18n.t('performances.google_locked')
      else
        redirect_to events_url(@event), notice: I18n.t('performances.destroyed')
      end
    else
      Rails.logger.debug('Rails event destroy failure')
      redirect_to event_url(@event),
                  notice: I18n.t('performances.fail_to_destroyed')
    end
  end

  private

  def add_to_google_calendar(google_service, event)
    opt = google_event_params(event)
    google_service.add_event_to_g_company_cal(opt)
  end

  def update_google_calendar(google_service, event)
    opt = google_event_params(event)
    google_service.update_event_google_calendar(opt)
  end

  def delete_google_calendar(google_service, event)
    google_service.delete_event_google_calendar(event)
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
