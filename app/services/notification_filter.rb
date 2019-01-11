class NotificationFilter < Notification

  def self.poll_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil? || poll.missing_voters_ids.empty?

    PollMailer.poll_reminder_mail(poll).deliver_now
  rescue StandardError => e
    Bugsnag.notify(e)
    Rails.logger.error("poll_reminder_mailing failure: #{e}")
    raise e
  end

  def self.poll_end_reminder_mailing(poll_id)
    poll = Poll.find_by(id: poll_id)
    return nil if poll.nil?

    PollMailer.poll_end_reminder_mail(poll).deliver_now!
  rescue StandardError => e
    # Bugsnag.notify(e)
    Rails.logger.error("poll_end_reminder_mailing failure: #{e}")
    raise e
  end

  # @item={
  # "class"=>"ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper",
  # "wrapped"=>"ReminderPollEndJob",
  # "queue"=>"mailers",
  # "args"=>
  #   [
  #     {
  #       "job_class"=>"ReminderPollEndJob",
  #       "job_id"=>"2db0c540-6bf3-49b2-b496-db22733b80bf",
  #       "provider_job_id"=>nil,
  #       "queue_name"=>"mailers",
  #       "priority"=>nil,
  #       "arguments"=>[39],
  #       "locale"=>"fr"
  #     }
  #   ],
  # "retry"=>true,
  # "jid"=>"a9decad10eb3374c7d74276a",
  # "created_at"=>1545506938.8081102}
end
