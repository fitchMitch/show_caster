# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  def perform(entity_id, klass, method_name)
    Rails.logger.debug("NotificationService.#{method_name}")
    NotificationFilter.send(method_name.to_sym, entity_id)
  rescue StandardError => e
    Bugsnag.notify(e)
    job_error_alert(klass, e)
  end

  def job_error_alert(job, exception)
    Rails.logger.error("Error !  #{exception} on #{job.name}")
  end
end
