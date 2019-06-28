class NotificationFilter < Notification

  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll).deliver_now
  end

  def self.poll_end_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil?

    PollMailer.poll_end_reminder_mail(poll).deliver_now
  end

  def self.course_reminder_mailing(course_id)
    course = Course.find_by(id: course_id)
    return nil if course.nil? || course.courseable.archived?

    CourseMailer.course_reminder_mail(course).deliver_now
  end
end
