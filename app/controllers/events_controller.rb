# frozen_string_literal: true

class EventsController < ApplicationController
  def edit; end

  def show; end

  def update
    if @event.update(event_params)
      @service = GoogleCalendarService.new(current_user)
      result = @service.update_google_calendar(@event)
      if (result.is_a? String) || result.nil?
        redirect_to events_url(@event),
                    notice: I18n.t('events.desynchronized')
      else
        redirect_to events_url(@event),
                    notice: I18n.t('events.updated_with_Google')
      end
    else
      flash[:alert] = I18n.t('events.update_failed')
      render 'edit'
    end
  end

  def destroy
    @service = GoogleCalendarService.new(current_user)
    if @event.destroy
      result = @service.delete_google_calendar(@event)
      if result.nil?
        redirect_to events_url(@event),
                    notice: I18n.t('performances.google_locked')
      else
        redirect_to events_url(@event), notice: I18n.t('performances.destroyed')
      end
    else
      Rails.logger.debug('Rails event destroy failure')
      redirect_to event_url(@event),
                  alert: I18n.t('performances.fail_to_destroyed')
    end
  end

  protected

  def set_type
    params[:type].downcase
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
