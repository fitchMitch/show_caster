# frozen_string_literal: true

class ReminderMailJob < ApplicationJob
  queue_as :mailers

  def perform(poll_id)
    super(poll_id, self.class, 'poll_reminder_mailing')
  end
end
