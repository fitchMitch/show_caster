# frozen_string_literal: true

class ReminderCourseMailJob < ApplicationJob
  queue_as :mailers

  def perform(course_id)
    super(course_id, self.class, 'course_reminder_mailing')
  end
end
