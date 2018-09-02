module MailerMacros
  def last_email
    condition = ActionMailer::Base.deliveries.empty?
    condition ? nil : ActionMailer::Base.deliveries.last
  end

  def last_email_address
    last_email.nil? ? nil : last_email.to.join
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def all_emails
    ActionMailer::Base.deliveries
  end

  def all_emails_sent_count
    ActionMailer::Base.deliveries.count
  end

  def all_email_addresses
    all_emails.map(&:to).flatten
  end
end
