# frozen_string_literal: true

class Notification
  @@too_short_notice_days = 2.days

  protected

  def self.too_short_notice_days
    @@too_short_notice_days
  end

  def self.short_notice(delay)
    delay < too_short_notice_days.to_i
  end
end
