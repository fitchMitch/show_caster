# frozen_string_literal: true

class ReminderPollEndJob < ApplicationJob
  queue_as :mailers

  def perform(poll_id)
    super(poll_id, self.class, 'poll_end_reminder_mailing')
  end
end
