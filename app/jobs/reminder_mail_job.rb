class ReminderMailJob < ApplicationJob
  include LoggingHelper
  queue_as :mailers

  def perform(poll_id)
    poll = Poll.find(poll_id)
    PollMailer.poll_reminder_mail(poll)
  # rescue StandardError => e
  #   Bugsnag.notify(e)
  #   warn_logging('ReminderJob failure') { puts e }
  end
end
