# frozen_string_literal: true

class EventsController < ApplicationController
  def edit; end

  def show; end

  def update
    if @event.update(event_params)
      redirect_to events_url(@event),
                  notice: I18n.t('events.updated')
    else
      flash[:alert] = I18n.t('events.update_failed')
      render 'edit'
    end
  end

  def destroy
    if @event.destroy
      NotificationService.destroy_all_notifications(@event)
      redirect_to events_url(@event),
                  notice: I18n.t('performances.destroyed')
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
