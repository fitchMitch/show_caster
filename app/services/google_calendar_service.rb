require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'

class GoogleCalendarService

  attr_accessor :cal

  def initialize(current_user)
      configure_client(current_user)
  end

  def configure_client(current_user)
    client_secrets = Google::APIClient::ClientSecrets.new(
      {"installed" =>
        { "access_token" => current_user.token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV['GOOGLE_CLIENT_ID'],
          "client_secret" => ENV['GOOGLE_CLIENT_SECRETS'],
        }
      }
    )
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = client_secrets.to_authorization
    @calendar.authorization.refresh!
    @calendar
  end

  def calendar_list
    @calendar.list_calendar_lists
  end

  def company_calendar_id
    "toto"
    # ENV['GOOGLE_CALENDAR_ID']
  end

  # Where primary is 'my' calendar
  def add_event_to_g_company_cal(opt)
    event = make_a_google_event(opt)
    @calendar.insert_event(company_calendar_id, event, send_notifications: true)
  end

  def update_event_google_calendar(opt)
    if opt.fetch(:fk, nil).nil?
      "inexisting Google Calendar event"
    else
      event = make_a_google_event(opt)
      @calendar.update_event(company_calendar_id,opt[:fk], event) if opt[:fk].present?
    end
  end

  def delete_event_google_calendar(event)
    event.fk.nil? ? nil : @calendar.delete_event(company_calendar_id,event.fk)
  end

  def make_a_google_event(opt)
    theater_name = opt.fetch(:theater_name, I18n.t("events.nowhere"))
    event_title = "events.#{opt.fetch(:title, "g_title.performance")}"
    event_hash = {
      summary: I18n.t(event_title, name: theater_name),
      location: opt.fetch(:location,I18n.t("events.nowhere")),
      description: I18n.t("events.mere_new_opus", name: theater_name),
      start: {
        date_time: opt.fetch(:event_date, nil),
        time_zone: 'Europe/Paris',
      },
      end: {
        date_time: opt.fetch(:event_end, nil),
        time_zone: 'Europe/Paris',
      },
      attendees: opt.fetch(:attendees_email,[]),
      reminders: {
        override: [
          {method: 'email', minutes: 2 * 24 * 60},
          {method: 'popup', minutes: 8 * 60 }
        ],
        use_default: false
      }
    }
    event_hash[:id] = opt[:fk] if opt.has_key?("fk")
    Google::Apis::CalendarV3::Event.new(event_hash)
  end
end
