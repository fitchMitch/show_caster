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
    ENV['GOOGLE_CALENDAR_ID']
  end

  # Where 'primary' is 'my' calendar
  def add_event_to_g_company_cal(opt)
    event = make_a_google_event(opt)
    @calendar.insert_event(company_calendar_id, event, send_notifications: true)
  end

  def existing_event?(id)
    begin
      response = @calendar.get_event( company_calendar_id, id )
      response.id == id
    rescue
      Rails.logger.debug("Calendar id fails here : #{id}")
      false
    end
  end

  def update_event_google_calendar(opt)
    begin
      if opt.fetch(:fk, nil).nil?
        "inexisting Google Calendar event"
      else
        if existing_event? opt[:fk]
          @calendar.update_event(company_calendar_id, opt[:fk], make_a_google_event(opt))
        else
          Rails.logger.debug("missing event in Google Calendar with id: #{opt[:fk]}")
          nil
        end
      end
    rescue
      Rails.logger.debug("API Call failed with #{$!} \nin update_event_google_calendar")
      nil
    end
  end

  def delete_event_google_calendar(event)
    begin
      if !event.try(:fk).nil? && existing_event?(event.fk)
        @calendar.delete_event(company_calendar_id, event.fk)
      else
        Rails.logger.debug("fails to delete from GCalendar event id/fk: #{event.id} / #{event.fk}")
        nil
      end
    rescue
      Rails.logger.debug("API Call failed with #{$!} \nin delete_event_google_calendar")
      nil
    end
  end

  def make_a_google_event(opt)
    theater_name = opt.fetch(:theater_name, I18n.t("events.nowhere"))
    event_title = "events.#{opt.fetch(:title, "g_title.performance")}"
    event_hash = {
      summary: I18n.t(event_title, name: theater_name),
      location: opt.fetch(:location, I18n.t("events.nowhere")),
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
