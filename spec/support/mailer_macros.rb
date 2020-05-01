# frozen_string_literal: true

module MailerMacros
  def last_email
    all_emails.empty? ? nil : all_emails.last
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
    all_emails.count
  end

  def all_email_addresses
    all_emails.map(&:to).flatten
  end
end
